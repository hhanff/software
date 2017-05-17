reset
set term svg  size 680,280

set output 'cd_2d.svg'
reset
set xlabel 'Velocity [m/s]'
set ylabel 'Drag coefficient [-]' rotate by 90

set style line 1 lc rgb "black"
set style line 2 lc rgb "red"

set style fill solid
set yrange [0:0.6]
set xrange [0.4:1.6]
set ytics 0.1
set xtics 0.5

plot "./cd_2d.dat" using 1:2 with linespoints ls 1 notitle, \
     "./cd_2d.dat" using 1:2:2 with labels offset 0,1 notitle, \
     "./cd_2d.dat" using 1:3 with linespoints ls 2 notitle, \
     "./cd_2d.dat" using 1:3:3 with labels offset 0,1 notitle
