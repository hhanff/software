#!/bin/bash
#iwlist s
sudo ifdown wlan0
sudo ifdown eth0
sudo /etc/init.d/ifupdown restart
sudo /etc/init.d/networking restart
sudo ifup eth0
ping 192.168.2.1

