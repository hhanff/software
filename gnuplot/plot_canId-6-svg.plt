#!/usr/bin/env gnuplot
reset
set term svg  size 1280,768
set output outputfile
set datafile separator " "

set xdata time
set timefmt "%H:%M:%S"
set format x "%H:%M:%S"
set xtics rotate
set xrange [:]

#set key autotitle columnheader

set xlabel 'Time [h:m:s]'
set xlabel offset 0,-10

set ytics 0.5
#set ytics 28.5,0.5
#set xtics 0.5

set ylabel offset -10,0

set macro
N=`awk 'NR==1{print NF}' @inputfile`

set ylabel "Temperature [$^\\\circ$C]"

#set key right bottom title ''
plot for [i=2:N] inputfile every 50 using 1:i with lines notitle
