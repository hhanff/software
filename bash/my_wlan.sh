#!/bin/bash
#iwlist s
sudo /etc/init.d/ifupdown restart
sudo /etc/init.d/networking restart
sudo ifdown eth0
sudo ifdown wlan0
sudo ifup wlan0
ping 192.168.2.1

