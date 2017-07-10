#include "serialcom.h"
#include <stdio.h>

//#define DEBUG_RX 1

/**
 * @brief Serialcom ctor
 *
 * Serialcom ctor creates two thread which handle
 * the receive and send tasks.
 */
Serialcom::Serialcom::Serialcom(QObject *parent)
    : QObject(parent)
{

#ifdef linux
    portHandle = -1;
#else // WINDOWS
    portHandle = INVALID_HANDLE_VALUE;
#endif // UNIX/WINDOWS

    receiveThread = new ReceiveThread(this);
    sendThread = new SendThread(this);

    QObject::connect(sendThread, SIGNAL(dataTransmitted(const QByteArray &)), SLOT(dataTransmittedSlot(const QByteArray &)));
    QObject::connect(receiveThread, SIGNAL(newData(const QByteArray &)), SLOT(dataReceived(const QByteArray &)));
    QObject::connect(receiveThread, SIGNAL(lostConnection()), SLOT(connectionLost()));

#ifdef DEBUG_RX
    debugRXFile = NULL;
    if ((debugRXFile = fopen("debugRX_Serialcom.txt","wb")) == NULL) {
        printf("ERROR(UART_connect): Can't open debugRX_Serialcom.txt.\n");
    }
#endif
}

/**
 * @brief Serialcom dtor
 *
 * Serialcom dtor terminates the two thread which handle
 * the receive and send tasks.
 */
Serialcom::Serialcom::~Serialcom()
{
    disconnect();

#ifdef DEBUG_RX
    fclose(debugRXFile);
#endif
}

/**
 * @brief Try to establish a connection to a serial port.
 *
 * @param port serial port to connect to
 * @param baud baud rate for the serial port
 * @param parity parity for the serial port (NO_PARITY, EVEN_PARITY, ODD_PARITY)
 * @return true connection is established
 *          false connection failed
 */
bool Serialcom::Serialcom::connect(const char *port, int baud, int parity)
{
#ifdef linux
    portHandle = UART_connect(port, baud, parity, &oldtio);

    if (portHandle < 1) {
        printf("ERROR(Serialcom): UART_connect failed.\n");
        return false;
    }
#else // WINDOWS
    portHandle = UART_connect(port, baud, parity);

    if (portHandle == INVALID_HANDLE_VALUE) {
        printf("ERROR(Serialcom): UART_connect failed.\n");
        return false;
    }
#endif // UNIX/WINDOWS

    sendThread->setFileHandle(portHandle);
    receiveThread->setFileHandle(portHandle);
    sendThread->start();
    receiveThread->start();

    return true;
}

/**
 * @brief Close the serial connection.
 */
void Serialcom::Serialcom::disconnect()
{
#ifdef linux
    if (portHandle < 0) return;
#else // windows
    if (portHandle == INVALID_HANDLE_VALUE) return;
#endif // linux/windows

    sendThread->terminate();
    receiveThread->terminate();

#ifdef linux
    UART_disconnect(portHandle, &oldtio);
    portHandle=-1;
#else // WINDOWS
    UART_disconnect(portHandle);
    portHandle=INVALID_HANDLE_VALUE;
#endif // UNIX/WINDOWS
}

bool Serialcom::Serialcom::isConnected()
{
#ifdef linux
    if (portHandle < 0) return false;
    else return true;
#else // WINDOWS
    if (portHandle == INVALID_HANDLE_VALUE) return false;
    else return true;
#endif // UNIX/WINDOWS
}

/**
 * @brief Send data.
 *
 * @param data
 */
void Serialcom::Serialcom::send(const QByteArray &data)
{
    //UART_send(portHandle, data.constData(), data.length());
    sendThread->sendData(data);
}

int Serialcom::Serialcom::blockingSend(const QByteArray &data)
{
    return sendThread->blockingSend(data);
}

void Serialcom::Serialcom::cancelSend()
{
    sendThread->cancel();
}

void Serialcom::Serialcom::dataReceived(const QByteArray &data)
{
#ifdef DEBUG_RX
    fwrite(data.constData(), 1, data.length(), debugRXFile);
    fflush(debugRXFile);
#endif

    emit newData(data);
}

void Serialcom::Serialcom::dataTransmittedSlot(const QByteArray &data)
{
    emit dataTransmitted(data);
}

void Serialcom::Serialcom::connectionLost()
{
    emit lostConnection();
}

void Serialcom::Serialcom::setSendBufferSize(int size)
{
    sendThread->setBufferSize(size);
}

int Serialcom::Serialcom::getSendBufferSize()
{
    return sendThread->getBufferSize();
}

// -------------------------------------- ReceiveThread --------------------------------------------

Serialcom::ReceiveThread::ReceiveThread(QObject *parent)
    : QThread(parent)
{
#ifdef linux
    portHandle = -1;
#else // WINDOWS
    portHandle = INVALID_HANDLE_VALUE;
#endif // UNIX/WINDOWS
    stopRunning = false;
}

Serialcom::ReceiveThread::~ReceiveThread()
{
    stopRunning = true;
    wait(500); //wait max 500ms until thread stops
}

void Serialcom::ReceiveThread::run()
{
    char buf[MAX_BUFFER_LENGTH];
    int count;

#ifdef linux
    if (portHandle < 0) {
        printf("ERROR(ReceiveThread): no file descriptor set\n");
        return;
    }
#else // WINDOWS
    if (portHandle == INVALID_HANDLE_VALUE) {
        printf("ERROR(ReceiveThread): no file descriptor set\n");
        return;
    }
#endif // UNIX/WINDOWS

    while (!stopRunning) {

        // wait for received data
        count = UART_receive(portHandle, buf, MAX_BUFFER_LENGTH);

        if (count==0) {
            emit lostConnection();
            break;
        }

        // emit newData signal
        emit newData(QByteArray(buf,count));
    }
}

// -------------------------------------- SendThread -----------------------------------------------

Serialcom::SendThread::SendThread(QObject *parent)
    : QThread(parent)
{
#ifdef linux
    portHandle = -1;
#else // WINDOWS
    portHandle = INVALID_HANDLE_VALUE;
#endif // UNIX/WINDOWS
    stopRunning = false;

    bufferSize=MAX_BUFFER_LENGTH;
}

Serialcom::SendThread::~SendThread()
{
    stopRunning = true;
    wait(500); //wait max 500ms until thread stops
}

void Serialcom::SendThread::run()
{
    QByteArray data;
    buffer.clear();

#ifdef linux
    if (portHandle < 0) {
        printf("ERROR(SendThread): no file descriptor set\n");
        return;
    }
#else // WINDOWS
    if (portHandle == INVALID_HANDLE_VALUE) {
        printf("ERROR(SendThread): no file descriptor set\n");
        return;
    }
#endif // UNIX/WINDOWS

    while (!stopRunning)
        {
            // check if there is at minimum one byte availabe to send otherwise lock here
            // untill at minimum one byte is available
            doSend.acquire();

            bufferMutex.lock();
            if (buffer.length()>0)
                {
                    if (buffer.length()<bufferSize)
                        data = QByteArray(buffer.constData(),buffer.length());
                    else
                        data = QByteArray(buffer.constData(),bufferSize);

                    buffer.remove(0,data.length());
                }
            bufferMutex.unlock();

            // acquire the rest of bytes which where available and are now to be send
            if (!doSend.tryAcquire(data.length()-1)) {
                qCritical("Serialcom: not enough Semaphores sendThread to aquire.\n");
                // an error happend but try to acquire at least available semaphores
                int available = doSend.available();
                doSend.acquire((available>data.length()-1)?(data.length()-1):available);
            }

            if (data.length()>0)
                {
                    UART_send(portHandle,data.constData(),data.length());

                    emit dataTransmitted(data);
                }
        }
}

void Serialcom::SendThread::sendData(const QByteArray &data)
{
#ifdef linux
    if (portHandle < 0) {
        printf("ERROR(SendThread): no file descriptor set\n");
        return;
    }
#else // WINDOWS
    if (portHandle == INVALID_HANDLE_VALUE) {
        printf("ERROR(SendThread): no file descriptor set\n");
        return;
    }
#endif // UNIX/WINDOWS
    bufferMutex.lock();
    buffer.append(data);
    bufferMutex.unlock();

    // release (create) number of bytes which should to be send
    doSend.release(data.length());
}

int Serialcom::SendThread::blockingSend(const QByteArray &data)
{
    int count=0;

#ifdef linux
    if (portHandle < 0) {
        printf("ERROR(SendThread): no file descriptor set\n");
        return -1;
    }
#else // WINDOWS
    if (portHandle == INVALID_HANDLE_VALUE) {
        printf("ERROR(SendThread): no file descriptor set\n");
        return -1;
    }
#endif // UNIX/WINDOWS

    bufferMutex.lock();

    while (count < data.length())
        count += UART_send(portHandle, data.constData()+count, data.length()-count);

    bufferMutex.unlock();

    return count;
}

void Serialcom::SendThread::cancel()
{
    bufferMutex.lock();
    buffer.clear();
    bufferMutex.unlock();
}
