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
r25 = 3000;
b25 = 4184.0;
t25 = 298.0;
tk2c = 281;
c1 = 100;
d1 = 100;

# Formula from Roman Sczuka
f_roman(x)=-180.8*log(log(x))+401.42;

# Fornula from book, basically a simplified version of f_full(x)
f_simple(x) =  1.0/(log(x/r25)/b25+1/t25)-tk2c;

# Formula from Vishays NTC application note, actually not better than the simple one (https://www.vishay.com/docs/29053/ntcintro.pdf)
f_full(x) = 1.0/(1.0/t25+1/b25*log(x/r25))+1.0/c1*(log(x/r25)**2+1.0/d1*(log(x/r25))**3)-tk2c

# # Try to fit
# FIT_LIMIT = 1e-6
# set fit errorvariables
# fit [50:350000]  f_full(x) "ntc_conversion_values_from_datasheet.dat" using 3:1 via c1, d1 ,tk2c #, r25, b25, t25, tk2c

# Plot, data for first plot is taken from NTC datasheet (https://www.vishay.com/doc?29118)
plot "ntc_conversion_values_from_datasheet.dat" using 2:1 with linespoints ls 3 title "Plotted values from data sheet", \
     f_simple(x) title "f(x) (Hendrik)" ls 4, \
     f_roman(x) title "f(x) (Roman)" ls 1
     # f_full(x) title "f_full(x)" ls 2
