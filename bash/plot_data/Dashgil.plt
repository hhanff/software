#-------------------------------------------------------------------------------
#-- Title      : Dashgil plot script for gnuplot
#-- Project    : Mud vulcano project
#-------------------------------------------------------------------------------
#-- File       : Dashgil.plt
#-- Author     : Hendrik Hanff
#-- Company    : MARUM/RCOM, Bremen, Germany
#-- Created    : 07\n07-29
#-- Last update: 07\n08-27
#-- Platform   : Windows XP - but should work under all other platforms
#--              supported by GnuPlot
#-- Standard   : Gnuplot 4.0
#-------------------------------------------------------------------------------
#-- Description: Outputs graphs from the Dashgil mud-vulcanoe data
#-------------------------------------------------------------------------------
#-- Copyright (c) 07 Hendrik Hanff
#-------------------------------------------------------------------------------
#-- Revisions  :
#-- Date        Version  Author  Description
#-- 07-09-29    1.0      hhanff  - Created
#-- 07-11-19    1.1      hhanff  - Changed the looking on the x-axis of the plots
#--                              - Added the DATE constant
#-------------------------------------------------------------------------------
#DATE = 01.10.07
#four = "4"
# This sets the graphs resolution
set samples 600
# This prints a timestamp to the graphs
set timestamp "%Y-%m-%dT%T%z"
# Initial stuff:
# Set output terminal and output mode:
#set terminal windows 'arial' 12
#set terminal png size 1280,1024; set output "UBat.png"
#set terminal postscript landscape enhanced color blacktext solid; set output "UBat.ps"
#set terminal svg size 1280 1024 fixed fsize 28 enhanced
# Setzt die Ausgabe zurueck aufs urspruengliche Ausgabefenster
#set terminal X11
set terminal gif transparent size 1280,960; set output "UBat.gif"
#set terminal postscript
set pointsize 0.5

# Wichtig: Trennt die Verbindung zur ausgegebenen Datei
#unset output

set grid
set datafile separator ","
set datafile separator whitespace
#set datafile commentschars "#"

# No legend:
#set nokey

# Set ranges:
#set xrange [.1:20]
#set s2range [0:10]
#set yrange [.1:10]
#set y2range [6:6.1]
set autoscale
#set noautoscale

# Stuff to handle time format:
#set xdata time
#set timefmt "%s"
#set format x "%d/%m\n%H:%M"
#set timefmt "%m/%d/%y %H:%M"

# Axis on right side of the diagramm without the same scaling as the left y-axis:
set ytics nomirror
set y2tics nomirror

# Set tics:
# Abstandsparameter
a=1.0
# Achsenbeschriftung x-axis
#set xdata time
#set timefmt "%d/%m"
#set format x "%b %d"
#set xrange ["01/10":"18/11"]
# rotate the x-labels by 90 degrees
set xtics rotate
## output the x-labels
#set xtics "01.10.2007", 2, "17.11.2007"

set xtics ( "28.06" 39261.0, "29.06" 39262.0, "30.06" 39263.0, "01.07" 39264.0,\
            "02.07" 39265.0, "03.07" 39266.0, "04.07" 39267.0, "05.07" 39268.0,\
            "06.07" 39269.0, "07.07" 39270.0, "08.07" 39271.0, "09.07" 39272.0,\
            "10.07" 39273.0, "11.07" 39274.0, "12.07" 39275.0, "13.07" 39276.0,\
            "15.07" 39277.0, "15.07" 39278.0, "16.07" 39279.0, "17.07" 39280.0,\
            "18.07" 39281.0, "19.07" 39282.0, "20.07" 39283.0, "21.07" 39284.0,\
            "22.07" 39285.0, "23.07" 39286.0, "24.07" 39287.0, "25.07" 39288.0,\
            "26.07" 39289.0, "27.07" 39290.0, "28.07" 39291.0, "29.07" 39292.0,\
            "30.07" 39293.0, "31.07" 39294.0, "01.08" 39295.0, "02.08" 39296.0,\
            "03.08" 39297.0, "04.08" 39298.0, "05.08" 39299.0, "06.08" 39300.0,\
            "07.08" 39301.0, "08.08" 39302.0, "09.08" 39303.0, "10.08" 39304.0,\
            "11.08" 39305.0, "12.08" 39306.0, "13.08" 39307.0, "14.08" 39308.0,\
            "15.08" 39309.0, "16.08" 39310.0, "17.08" 39311.0, "18.08" 39312.0,\
            "19.08" 39313.0, "20.08" 39314.0, "21.08" 39315.0, "22.08" 39316.0,\
            "23.08" 39317.0, "24.08" 39318.0, "25.08" 39319.0, "26.08" 39320.0,\
            "27.08" 39321.0, "28.08" 39322.0, "29.08" 39323.0, "30.08" 39324.0,\
            "31.08" 39325.0, "01.09" 39326.0, "02.09" 39327.0, "03.09" 39328.0,\
            "04.09" 39329.0, "05.09" 39330.0, "06.09" 39331.0, "07.09" 39332.0,\
            "08.09" 39333.0, "09.09" 39334.0, "10.09" 39335.0, "11.09" 39336.0,\
            "12.09" 39337.0, "13.09" 39338.0, "14.09" 39339.0, "15.09" 39340.0,\
            "16.09" 39341.0, "17.09" 39342.0, "18.09" 39343.0, "19.09" 39344.0,\
            "20.09" 39345.0, "21.09" 39346.0, "22.09" 39347.0, "23.09" 39348.0,\
            "24.09" 39349.0, "25.09" 39350.0, "26.09" 39351.0, "27.09" 39352.0,\
            "28.09" 39353.0, "29.09" 39354.0, "30.09" 39355.0, "01.10" 39356.0,\
            "02.10" 39357.0, "03.10" 39358.0, "04.10" 39359.0, "05.10" 39360.0,\
            "06.10" 39361.0, "07.10" 39362.0, "08.10" 39363.0, "09.10" 39364.0,\
            "10.10" 39365.0, "11.10" 39366.0, "12.10" 39367.0, "13.10" 39368.0,\
            "14.10" 39369.0, "15.10" 39370.0, "16.10" 39371.0, "17.10" 39372.0,\
            "18.10" 39373.0, "19.10" 39374.0, "20.10" 39375.0, "21.10" 39376.0,\
            "22.10" 39377.0, "23.10" 39378.0, "24.10" 39379.0, "25.10" 39380.0,\
            "26.10" 39381.0, "27.10" 39382.0, "28.10" 39383.0, "29.10" 39384.0,\
            "30.10" 39385.0, "31.10" 39386.0, "01.11" 39387.0, "02.11" 39388.0,\
            "03.11" 39389.0, "04.11" 39390.0, "05.11" 39391.0, "06.11" 39392.0,\
            "07.11" 39393.0, "08.11" 39394.0, "09.11" 39395.0, "10.11" 39396.0,\
            "11.11" 39397.0, "12.11" 39398.0, "13.11" 39399.0, "14.11" 39400.0,\
            "15.11" 39401.0, "16.11" 39402.0, "17.11" 39403.0, "18.11" 39404.0,\
            "19.11" 39405.0, "20.11" 39406.0, "21.11" 39407.0, "22.11" 39408.0,\
            "23.11" 39409.0, "24.11" 39410.0, "25.11" 39411.0, "26.11" 39412.0,\
            "27.11" 39413.0, "28.11" 39414.0, "29.11" 39415.0, "30.11" 39416.0,\
            "01.12" 39417.0, "02.12" 39418.0, "03.12" 39419.0, "04.12" 39420.0,\
            "05.12" 39421.0, "06.12" 39422.0, "07.12" 39423.0, "08.12" 39424.0,\
            "09.12" 39425.0, "10.12" 39426.0, "11.12" 39427.0, "12.12" 39428.0,\
            "13.12" 39429.0, "14.12" 39430.0, "15.12" 39431.0, "16.12" 39432.0,\
            "17.12" 39433.0, "18.12" 39434.0, "19.12" 39435.0, "20.12" 39436.0,\
            "21.12" 39437.0, "22.12" 39438.0, "23.12" 39439.0, "24.12" 39440.0,\
            "25.11" 39441.0, "26.12" 39442.0, "27.12" 39443.0, "28.12" 39444.0,\
            "29.12" 39445.0, "30.12" 39446.0, "31.12" 39447.0, "01.01" 39448.0)

# For logscale use:
#set logscale xy
#unset logscale 
#plot[1:20] [.1:10] "temp7.dat"      using 1:2 smooth csplines title "fg = 2kHz" with points
##################################
#UBat
##################################
# Set titles and labels:
set title "Mud volcanoe Dashgil, Azerbaijan\n Date: "
set xlabel "Time"
set ylabel "UBat \n [V]"

# Plot the data:
#plot"temp7.dat" every ::3 using (1*$1):(2*$15) smooth csplines title "Big salse: U\_Bat" with lines lt 1 axis x1y1,\
#    "temp7.dat" every ::3 using (1*$1):(2*$7)  smooth csplines title "Small salse: U\_Bat" with lines lt 2 axis x1y2 set datafile missing "NaN"
plot"temp7.dat" every ::3 using (1*$1):(2*$15) title "Big salse: U\_Bat" with points pt 64 lt 1 axis x1y1
#    "temp7.dat" every ::3 using (1*$1):(2*$7)  title "Small salse: U\_Bat" with points pt 1 lt 2 axis x1y2
    
# 'with' can be lines, dots, points, linespoints, impulses, steps, boxes,
#  xerrorbars, yerrorbars, xyerrorbars, vector, ...

# The syntax for every is
# every I:J:K:L:M:N 	
# I 	Line increment
# J 	Data block increment
# K 	The first line
# L 	The first data block
# M 	The last line
# N 	The last data block 
# e.g.
# every 2 		plot every 2 line
# every ::3 		skip the first 3 lines
# every ::3::5 		plot from the 4-th to 6-th lines
# every ::0::0 		plot the first line only
# every 2::::6 		plot the 1,3,5,7-th lines
# every :2 		plot every 2 data block
# every :::5::8 	plot from 5-th to 8-th data blocks

# Alternatives to "smooth csplines":
#smooth bezier
#with pointspoints

# POINT SIZE AND TYPE
# pointsize is to expand points
#  set pointsize 2.5
# type 'test' to see the colors and point types available
# lt is for color of the points: -1=black 1=red 2=grn 3=blue 4=purple 5=aqua 6=brn 7=orange 8=light-brn
# pt gives a particular point type: 1=diamond 2=+ 3=square 4=X 5=triangle 6=*
# postscipt: 1=+, 2=X, 3=*, 4=square, 5=filled square, 6=circle,
#            7=filled circle, 8=triangle, 9=filled triangle, etc.

# LINE COLORS, STYLES 
# type 'test' to see the colors and point types available.
# Differs from x11 to postscript
# lt chooses a particular line type: -1=black 1=red 2=grn 3=blue 4=purple 5=aqua 6=brn 7=orange 8=light-brn
# lt must be specified before pt for colored points
# for postscipt -1=normal, 1=grey, 2=dashed, 3=hashed, 4=dot, 5=dot-dash
# lw chooses a line width 1=normal, can use 0.8, 0.3, 1.5, 3, etc.
# ls chooses a line style
#  plot sin(x)k with pointspoints lt 2 pt 4

#set output "seismik-plot.ps"
#replot
#set output "seismik-plot.png"
#replot
#set output "seismik-plot.svg"
#replot
print "UBat printed..."
##################################
#Gasflow
##################################
# Set titles and labels:
set title "Mud volcanoe Dashgil, Azerbaijan\n Date: "
set xlabel "Time"
set ylabel "Gasflow \n [ml/h]"

# set ranges
 set autoscale
#set yrange[0:0.3]
#set y2range[0:1.3]

set terminal gif transparent size 1280,960; set output "GasFlow.gif"
plot"temp7.dat" every ::3 using (1*$1):(1*$12) title "Big salse, big float: Gas Flow" with points  pt 64 lt 1 axis x1y1,\
    "temp7.dat" every ::3 using (1*$1):(1*$13) title "Big salse, small float: Gas Flow" with points  pt 1 lt 2 axis x1y2

## replot
print "Gasflow printed..."

##################################
#Temperature
##################################
# Set titles and labels:
set title "Mud volcanoe Dashgil, Azerbaijan\n Date: "
set xlabel "Time"
set ylabel "Temperature \n [°C]"

# set ranges
set autoscale
#set yrange[25:100]
#set y2range[25:30]

set terminal gif transparent size 1280,960; set output "Temperature.gif"
plot"temp7.dat" every ::3 using (1*$1):(1*$8) title "Big salse, lower temperature" with points  pt 64 lt 1 axis x1y1,\
    "temp7.dat" every ::3 using (1*$1):(1*$14) title "Big salse, upper temperature" with points  pt 1 lt 2 axis x1y2

##replot
print "Temperature printed..."

##################################
#Inclination
##################################
# Axis on right side of the diagramm without the same scaling as the left y-axis:
unset y2tics

# Set titles and labels:
set title "Mud volcanoe Dashgil, Azerbaijan\n Date: "
set xlabel "Time"
set ylabel "Inclination \n [deg]"

# set ranges
set autoscale
#set yrange[2.95:3.05]

set terminal gif transparent size 1280,960; set output "Inclination.gif"
plot"temp7.dat" every ::3 using (1*$1):(1*$11) title "Big salse, inclination" with points  pt 1 lt 1 axis x1y1

## replot
print "Inclination printed..."

##################################
#Real Lower pressure
##################################
# Set titles and labels:
set title "Mud volcanoe Dashgil, Azerbaijan\n Date: "
set xlabel "Time"
set ylabel "Real Lower Pressure \n [Bar]"

# set ranges
set autoscale
#set yrange[0.09:0.115]

set terminal gif transparent size 1280,960; set output "Lower Pressure.gif"
plot"temp7.dat" every ::3 using (1*$1):(1*$9) title "Big salse, Real lower pressure" with points pt 1 lt 1 axis x1y1

## replot
print "Real lower pressure printed..."

    
