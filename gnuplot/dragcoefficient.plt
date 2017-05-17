reset
set term svg  size 680,280

set output 'dragcoefficient.svg'
#set xlabel 'AUV version'
reset
set ylabel 'Drag coefficient [-]' rotate by 90

set style line 1 lc rgb "red"
set style line 2 lc rgb "blue"
set style line 3 lc rgb "green"

set style fill solid
set boxwidth 0.5
set yrange [0:0.5]


plot "./dragcoefficient.dat" every ::0::0 using 1:3:xtic(2) with boxes ls 1 notitle, \
     "./dragcoefficient.dat" every ::0::0 using 1:3:3 with labels offset 0,1 notitle, \
     "./dragcoefficient.dat" every ::1::1 using 1:3:xtic(2) with boxes ls 2 notitle, \
     "./dragcoefficient.dat" every ::1::1 using 1:3:3 with labels offset 0,1 notitle, \
     "./dragcoefficient.dat" every ::2::2 using 1:3:xtic(2) with boxes ls 3 notitle, \
     "./dragcoefficient.dat" every ::2::2 using 1:3:3 with labels offset 0,1 notitle
