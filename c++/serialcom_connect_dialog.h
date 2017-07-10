/**
 * @addtogroup Serialcom
 * @{
 */
#ifndef _SERIALCOM_CONNECTDIALOG_H_
#define _SERIALCOM_CONNECTDIALOG_H_

#include <QDialog>
#include <QComboBox>
#include <QLayout>
#include <QDialogButtonBox>

namespace Serialcom
{

    namespace Ui
    {
        class SerialcomConnectDialog;
    };

    /**
     * @brief A Dialog to select port, baudrate and parity of a serial connection.
     *
     * With this dialog a user can select the port, baudrate and parity of a
     * serial connection.
     *
     * @sa @ref Serialcom
     */
    class SerialcomConnectDialog : public QDialog
    {
        Q_OBJECT

            public:
        /** Default constructor */
        SerialcomConnectDialog(QDialog *parent=0);
        /** Default destructor */
        virtual ~SerialcomConnectDialog();

        QString getPortName();
        int getBaudRate();
        int getParity();

    private:
        Ui::SerialcomConnectDialog* mpUi;
    };

};

#endif //_SERIALCOM_CONNECTDIALOG_H_

/**
 * @}
 */
