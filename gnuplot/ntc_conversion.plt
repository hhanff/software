reset

set term png  size 3000,1500
set output 'ntc_conversion.png'

# set term svg  size 680,280
# set output 'ntc_conversion.svg'

set xlabel 'Resistance [Ohm]'
set ylabel 'Temperature [deg]'

set style line 1 lc rgb "black"
set style line 2 lc rgb "red"
set style line 3 lc rgb "blue"
set style line 4 lc rgb "green"
set style line 5 lc rgb "yellow"

set datafile separator ";"
set datafile commentschars "#"

set key left bottom Left title 'Legend' box 3
set yrange [-60:155]
set logscale x

# Values from Vishay NTC datasheet
r25 = 3000.0;
b25 = 3984.0;
t25 = 298.0;
tk2c = 280.0;
c1 = 92884
d1 = 2.13595e+07;

# Formula from Roman Sczuka
f_roman(x)=-180.8*log(log(x))+395.42;

# Fornula from book
f_simple(x) =  1.0/(log(x/r25)/b25+1/t25)-tk2c;

# Formula from Vishays NTC application note
f_full(x) = 1.0/(1.0/t25+1/b25*log(x/r25))+1.0/c1*(log(x/r25)**2+1.0/d1*(log(x/r25))**3)-tk2c

# Do the fit
# FIT_LIMIT = 1e-6
# fit f_full(x) "ntc_conversion_values_from_datasheet.dat" using 3:1 via c1,d1

plot "ntc_conversion_values_from_datasheet.dat" using 2:1 with linespoints ls 3 title "Values from data sheet", \
     f_simple(x) title "f_simple(x)" ls 4, \
     f_full(x) title "f_full(x)" ls 5, \
     f_roman(x) title "f_roman(x)" ls 1
