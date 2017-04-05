#!/bin/bash
#-------------------------------------------------------------------------------
#-- Title       : Install the stm32 toolchain
#-- Project     : SeeGrip
#-- Library:    : 
#-------------------------------------------------------------------------------
#-- File name   : install_stm32_toolchain.sh
#-- Author      : hhanff
#-- Company     : DFKI
#-- Last update : 
#-- Platform    : 2011-07-01
#-------------------------------------------------------------------------------
#-- Purpose     : Installs the stm32 toolchain, containing the appropriate compiler
#--               and the openocd application to flash the stm32 via a kt-link pro
#--               grammer
#-------------------------------------------------------------------------------
#-- Assumptions : 
#-- Limitations :
#-- Known Errors:
#-- Notes       : 
#-------------------------------------------------------------------------------
#-- Revisions   :
#-- Date        Version  Author          Description
#-- 2011-07-01  1.0      Hendrik Hanff	Created
#-------------------------------------------------------------------------------

cd /tmp
#wget http://www.codesourcery.com/sgpp/lite/arm/portal/package2549/public/arm-none-linux-gnueabi/arm-2008q1-126-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
#tar -jxvf arm-2008q1-126-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2
#sudo mv arm-2008q1 /opt
#wget https://sourcery.mentor.com/GNUToolchain/package9489/public/m68k-linux-gnu/freescale-coldfire-2011.09-22-m68k-linux-gnu-i686-pc-linux-gnu.tar.bz2
wget https://sourcery.mentor.com/GNUToolchain/package10928/public/arm-none-eabi/arm-2012.09-63-arm-none-eabi.bin
chmod +x *arm-none-eabi*
sudo ./*arm-none-eabi*
#echo 'export PATH=$PATH:/opt/arm-2008q1/bin' >> ~/.bashrc
#sudo apt-get install openocd
#make -B && make flash
cd -
