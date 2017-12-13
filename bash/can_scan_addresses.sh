#!/bin/bash
##-----------------------------------------------------------------------------
## Title       : can_scan_addresses
## Project     :
## Library:    :
##-----------------------------------------------------------------------------
## File name   : can_scan_addresses.sh
## Author      : hhanff
## Company     :
## Last update :
## Platform    : lin
##-----------------------------------------------------------------------------
## Purpose     : Upper part:
##               Scans all can addresses with can send. Can bus can be observed
##               with
##               > candump can0
##               Lower part:
##               Successively increases data bytes
##
##-----------------------------------------------------------------------------
## Assumptions :
## Limitations :
## Known Errors:
##-----------------------------------------------------------------------------
## Revisions   :
## Date        Version  Author          Description

##-----------------------------------------------------------------------------
# error on first failed command or unreferencing a undefined variable:
set -eu
set -x

# # set motor control pwm value
# # > cansend can0 012#40.00.00.00.00.00.00.00
for i in {0..15}; do
   for j in {0..15}; do
       for k in {0..15}; do
	   for l in {0..0}; do
	# printf is capable of doing the conversion to hexadecimal
		   sleep 1
	       CAN_MESSAGE=`printf '%X%X%X#%X%X.%X%X' "$i" "$j" "$k"  "$i" "$j" "$k" "$l"`
	       echo "Can message: $CAN_MESSAGE"
           sudo ifconfig can0 down 
           sudo ip link set can0 type can bitrate 1000000 triple-sampling on 
           sudo ifconfig can0 txqueuelen 1000
           sudo ifconfig can0 up
               cansend can0 $CAN_MESSAGE
#	       sleep 0.01
	       l+=10;
	   done
       done
   done
done
