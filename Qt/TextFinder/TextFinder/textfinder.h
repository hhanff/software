#ifndef TEXTFINDER_H
#define TEXTFINDER_H

#include <QWidget>

namespace Ui {
    class TextFinder;
}

class TextFinder : public QWidget {
    Q_OBJECT
public:
    TextFinder(QWidget *parent = 0);
    ~TextFinder();

protected:
    void changeEvent(QEvent *e);

private:
    Ui::TextFinder *ui;
    void loadTextFile();

private slots:
    void on_findButton_clicked();

};

#endif // TEXTFINDER_H
