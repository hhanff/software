#!/usr/local/bin/gnuplot -persist
set datafile separator ","
set term svg
set output "control.svg"
# set yrange [0:160]
# set xrange [0:100]
set key bottom right
set grid
set xlabel 't[ms]'
set ylabel 'PID reply'
plot './tempplot3to1_4-1.csv' using ($1/1000):($2) with linespoints title "Desired value (w(t))", \
     '../sim/pid_sim.txt' using ($1/1000):($3) with linespoints title "Control value (y(t))", \
     '../sim/pid_sim.txt' using ($1/1000):($4/100000) with linespoints title "Control Output (u(t))"
exit
quit

#plot    "data" using ($0):($3) title "Zeiten in sec" linetype 1, \
#        "" using ($0):($5>=0 ? $3 : 0) linetype 2e
