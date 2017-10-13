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

set datafile separator ";"
set datafile commentschars "#"

     set key left bottom Left title 'Legend' box 3
# set style fill solid
set yrange [-60:155]
# set xrange [0.4:1.6]
# set ytics 0.1
# set xtics 0.5

# plot "../c/ntc_conversion.dat" using 1:2 with dots ls 1 title "Romans temperature conversion" , \
#      "../c/ntc_conversion.dat" using 1:3 with dots ls 2 title "Hendriks temperature conversion", \
#      "../c/ntc_conversion_values_from_datasheet.dat" using 2:1 with linespoints ls 3 title "Values from data sheet"
#      # "./cd_2d.dat" using 1:3:3 with labels offset 0,1 notitle
FIT_LIMIT = 1e-6
#FIT_LIMIT = 0.000001
# FIT_SKIP = 2

# Values from Vishay NTC datasheet
r25 = 3000.0;
b25 = 3984.0;
t25 = 298.0;
tk2c = 273.0;

a1 = tk2c
b1 = b25
c1 = 100.0
d1 = 100.0

# f(x) =  1.0/(log(x/r25)/b25+1/t25)-tk2c;
# f(x) = ((log(x/r25)/b25)+1/t25)-tk2c;

# Formula from Vishays NTC application note
f(x) = 1.0/(1.0/t25+1/b25*log(x/r25)/log(exp(1.0))+1.0/c1*(log(x/r25)/log(exp(1.0)))**2+1.0/d1*(log(x/r25)/log(exp(1.0)))**3)-tk2c

# Do the fit
fit f(x) "../c/ntc_conversion_values_from_datasheet_orig.dat" using 3:1 via c1,d1

# Plot a graph including both the fir _and_ the original data from the datasheet
plot [0:290000] "../c/ntc_conversion_values_from_datasheet_orig.dat" u 3:1, f(x)
