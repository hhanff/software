#!/bin/bash

gnatmake hello.adb

#gcc -c hello.adb
#gnatbind hello
#gnatlink hello

./hello

/bin/rm -rf *.o *.ali 
 
