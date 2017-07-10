#ifndef TASCHENRECHNER_H
#define TASCHENRECHNER_H
 
#include "ui_Taschenrechner.h"
 
class Taschenrechner : public QMainWindow, public Ui::MainWindow{
  Q_OBJECT
 
  public:
    Taschenrechner (QMainWindow *parent = 0);
    ~Taschenrechner();
};
#endif //TASCHENRECHNER_H
 
//--- Taschenrechner.h - end ---
