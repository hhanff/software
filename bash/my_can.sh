#!/bin/bash
##-----------------------------------------------------------------------------
## Title       : my_can
## Project     : SeeGrip
## Library:    : 
##-----------------------------------------------------------------------------
## File name   : my_can.sh
## Author      : hhanff
## Company     : DFKI
## Last update : 2011-11-19
## Platform    : lin
##-----------------------------------------------------------------------------
## Purpose     : Provides a means to automatically set up your system
##               to connect to the CAN/USB adapter
##               
##-----------------------------------------------------------------------------
## Assumptions : If your kernel version is not 2.6.35-25 you have to 
##               re-compile socketcan and iproute 2 for your machine.
##               This process is also described on:
##               https://svn.hb.dfki.de/SeeGrip-Trac/wiki/CAN
##               Brief description of this process:
##               > cd socketcan-usb/socketcan-usb2-patchV3/trunk/kernel/2.6
##               Evtl vorher in den Dateien esd_usb2.c und ems_usb.c die folgenden Funktionen ersetzen:
##                usb_buffer_alloc() is renamed to usb_alloc_coherent()
##                usb_buffer_free()  is renamed to usb_free_coherent()
##               >  make
##               >  mkdir /lib/modules/$(uname -r)/socketcan
##               >  find -name \*.ko | xargs  install -t /lib/modules/$(uname -r)/socketcan
##               >  depmod $(uname -r)
##
##               > cd socketcan-usb/iproute2
##               > make
##               >  make install
## Limitations :
## Known Errors:
##-----------------------------------------------------------------------------
## Revisions   :
## Date        Version  Author          Description
## 2011-12-19  1.0      Hendrik Hanff	Created
##-----------------------------------------------------------------------------
# error on first failed command or unreferencing a undefined variable:
#set -eu
#set -x

echo " " >> /tmp/can-usb
# Would be cool if somebody comes up with a method of testing if these
# modules are actually loaded and only remove them if they are loaded...
date >> /tmp/can-usb
echo "Closing link..." >> /tmp/can-usb
sudo /sbin/ip link set can0 down
echo "Unloading kernel modules..." >> /tmp/can-usb
if sudo grep "esd_usb2" /proc/modules; then
    sudo  rmmod esd_usb2
fi
if grep "ems_usb" /proc/modules; then
    sudo  rmmod ems_usb
fi
if grep "can_dev" /proc/modules; then
    sudo  rmmod can_dev 
fi
if grep "can_raw" /proc/modules; then
    sudo  rmmod can_raw 
fi
if grep "can" /proc/modules; then
    sudo  rmmod can 
fi
echo "Loading kernel modules..." >> /tmp/can-usb
sudo  insmod /lib/modules/2.6.35-25-generic/socketcan/can.ko
sudo  insmod /lib/modules/2.6.35-25-generic/socketcan/can-raw.ko
sudo  insmod /lib/modules/2.6.35-25-generic/socketcan/can-dev.ko
sudo  insmod /lib/modules/2.6.35-25-generic/socketcan/ems_usb.ko
sudo  insmod /lib/modules/2.6.35-25-generic/socketcan/esd_usb2.ko
echo "Drivers loaded" >> /tmp/can-usb
echo "Please DISconnect the USB to CAN vonverter from your PC and hit <Enter>"
read TRASH;
echo "Please connect the USB to CAN vonverter to your PC and hit <Enter>"
read TRASH;
/bin/sleep 3
echo "Starting link..." >> /tmp/can-usb
sudo /sbin/ip link set can0 up type can bitrate 1000000 restart-ms 1000

echo "Checking if device is registered..." >> /tmp/can-usb
# Test if can0 was really registered.
sudo tail -n 2 /var/log/messages | grep "can0 registered" >> /tmp/can-usb
exit 0