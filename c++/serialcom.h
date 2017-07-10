/**
 * @defgroup Serialcom
 * @{
 *
 * @brief Serialcom is a library to handle serial communication.
 *
 * The Serialcom library handles communication via a serial port.\n
 * The @link Serialcom::Serialcom @endlink class provides Qt functions
 * to connect/disconnect to a serial port and also slots and signals
 * to send/receive data.\n
 * The @link Serialcom::SerialcomConnectDialog @endlink could be used
 * as an user input to interactive select a port, the baudrate and other
 * port specific values.\n
 * For low-level c-style serial communication the functions in the
 * @link serial_communication.h @endlink file could be used.\n\n
 *
 * An example how this libray could be used to connect/disconnect a
 * serial port:
 * @code
 *    if (!mpPortHandler->isConnected()) {
 *
 *       ::Serialcom::SerialcomConnectDialog connectDialog;
 *
 *       if (connectDialog.exec()==QDialog::Accepted) {
 *
 *           QString portName = connectDialog.getPortName();
 *           int baudRate     = connectDialog.getBaudRate();
 *           int parity       = connectDialog.getParity();
 *
 *           if (mpPortHandler->connect(portName.toAscii().constData(),baudRate,parity)) {
 *               // connection was successfull
 *               printf("Connected.\n");
 *           } else {
 *               // connection not successfull (by underlying module)
 *               printf("Connection failed.\n");
 *               return;
 *           }
 *       }
 *
 *   } else {
 *       // disconnection was successfull
 *       mpPortHandler->disconnect();
 *       printf("Disconnected.\n");
 *   }
 * @endcode
 *
 * Message could be send in two possible ways:\n
 * 1. Non-blocking
 * @code mpPortHandler->send(byteArray); @endcode
 * 2. Blocking
 * @code mpPortHandler->blockingSend(byteArray); @endcode
 *
 * Receiving message could be done as followed:
 * @code
 * // signal-slot connection (in ctor)
 * connect(mpPortHandler,SIGNAL(newData(const QByteArray&)),SLOT(dataReceived(const QByteArray&)));
 * ...
 * void <class-name>::dataReceived(const QByteArray &data)
 * {
 *   // do something with the data
 * }
 * @endcode
 */
#ifndef _SERIALCOM_H_
#define _SERIALCOM_H_

#include <QThread>
#include <QMutex>
#include <QSemaphore>

#ifdef linux
#include <termios.h>
#else // WINDOWS
#include <windows.h>
#endif // UNIX/WINDOWS

extern "C" {
#include "serial_communication.h"
}

/**
 * @brief A namespace for the Serialcom library.
 *
 * @sa @ref Serialcom
 */
namespace Serialcom
{

    class ReceiveThread;
    class SendThread;

    /**
    * @brief This class handles a serial port.
    *
    * This class handles a serial port using the serial_communication.c functions.
    * It has two private thread objects which handle the receive and send tasks.
    * Sending can be done directly by calling @link SerialPortHandler::send send
    * @endlink if data is received @link SerialPortHandler::newData newData @endlink
    * signal is emitted.
    *
    * @sa @ref Serialcom
    */
    class Serialcom : public QObject
    {
        Q_OBJECT

            public:
        Serialcom(QObject *parent=NULL);
        ~Serialcom();

        bool connect(const char *port, int baud, int parity);
        void disconnect();
        bool isConnected();

        int blockingSend(const QByteArray &data);

        void setSendBufferSize(int size);
        int getSendBufferSize();

        public slots:
        void send(const QByteArray &data);
        void cancelSend();

    signals:
        /**
         * @brief This signal is emitted if new Data is available.
         *
         * @param[out] data
         */
        void newData(const QByteArray &data);

        /**
         * @brief This signal is emiited when a write operation
         *        is finished.
         *
         * @param[out] data
         */
        void dataTransmitted(const QByteArray &data);

        void lostConnection();

    private:
        ReceiveThread *receiveThread;
        SendThread    *sendThread;

        FILE *debugRXFile;

#ifdef linux
        int portHandle;
        struct termios oldtio;
#else // WINDOWS
        HANDLE portHandle;
#endif // UNIX/WINDOWS

        private slots:
        void dataReceived(const QByteArray &data);
        void dataTransmittedSlot(const QByteArray &data);
        void connectionLost();
    };


    // -----------------------------------------------------------------------------
    //                      private class to receive data
    // -----------------------------------------------------------------------------
    /**
     * @brief (Private) class to receive data.
     *
     * This class will be used by the @link Serialcom::Serialcom @endlink class
     * to receive data. This class should not be used explicitally.
     */
    class ReceiveThread : public QThread
    {
        Q_OBJECT

            public:
        ReceiveThread(QObject *parent=NULL);
        ~ReceiveThread();

#ifdef linux
        void setFileHandle(int _portHandle) { portHandle = _portHandle; }
#else // WINDOWS
        void setFileHandle(HANDLE _portHandle) { portHandle = _portHandle; }
#endif // UNIX/WINDOWS

        bool stopRunning;

        virtual void run();

    signals:
        void newData(const QByteArray &data);
        void lostConnection();

    private:
#ifdef linux
        int portHandle;
#else // WINDOWS
        HANDLE portHandle;
#endif // UNIX/WINDOWS
    };


    // -----------------------------------------------------------------------------
    //                      private class to receive data
    // -----------------------------------------------------------------------------
    /**
     * @brief (Private) class to send data.
     *
     * This class will be used by the @link Serialcom::Serialcom @endlink class
     * to send data. This class should not be used explicitally.
     */
    class SendThread : public QThread
    {
        Q_OBJECT

            public:
        SendThread(QObject *parent=NULL);
        ~SendThread();

#ifdef linux
        void setFileHandle(int _portHandle) { portHandle = _portHandle; }
#else // WINDOWS
        void setFileHandle(HANDLE _portHandle) { portHandle = _portHandle; }
#endif // UNIX/WINDOWS

        bool stopRunning;

        virtual void run();

        int blockingSend(const QByteArray &data);
        void cancel();

        void setBufferSize(int size) { bufferSize = size; }
        int getBufferSize() { return bufferSize; }

        public slots:
        void sendData(const QByteArray &data);

    signals:
        void dataTransmitted(const QByteArray &data);

    private:
#ifdef linux
        int portHandle;
#else // WINDOWS
        HANDLE portHandle;
#endif // UNIX/WINDOWS

        QMutex bufferMutex;
        QSemaphore doSend;
        QByteArray buffer;
        int bufferSize;
    };

};

#endif //_SERIALCOM_H_

/**
 * @}
 */
