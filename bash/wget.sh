#!/bin/bash
##-----------------------------------------------------------------------------
## Title       : 
## Project     : 
## Library:    : 
##-----------------------------------------------------------------------------
## File name   : 
## Author      : hhanff
## Company     : 
## Last update : 
## Platform    : lin
##-----------------------------------------------------------------------------
## Purpose     : 
##               
##               
##               
##               
##               
##               
##-----------------------------------------------------------------------------
## Assumptions : 
## Limitations :
## Known Errors:
##-----------------------------------------------------------------------------
## Revisions   :
## Date        Version  Author          Description
## 2011-12-14  1.
0      Hendrik Hanff	Created
##-----------------------------------------------------------------------------
# error on first failed command or unreferencing a undefined variable:
set -eu
set -x

for i in {0..0}; do
   for j in {0..15}; do
       for k in {0..15}; do
         wget http://server.picout.com/uploads/p14/c2872/"$i""$j""$k".jpg
	   done
   done
done

