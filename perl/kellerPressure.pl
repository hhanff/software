#!/usr/bin/perl

use strict;
use warnings;

# this is the module which does the calibration-calculations
# it returns the perfect value according to the vendor provided calibration
use KellerPressureSensorCalibrator;

# the ranges we should cover
my $Rb_min = 3300;
my $Rb_points = 100;
my $Rb_max = 3800;
my $Rb_stepsize = ($Rb_max - $Rb_min)/$Rb_points;

my $V_sens_min = 0;
my $V_sens_points = 100;
my $V_sens_max = 250;
my $V_sens_stepsize = ($V_sens_max - $V_sens_min)/$V_sens_points;

#print "kellerPressure.pl: running Rb from $Rb_min to $Rb_max witg stepsize $Rb_stepsize and V_sens from $V_sens_max to V_sens_max with steppsize of $V_sens_stepsize\n";

# plotting: we save a plt file, and invoke gnuplot to churn on it
sub plotRbdot {
    my $file = shift;
    my $type = shift;
    my $datname = $file."_".$type.".dat";
    my $pngname = $file."_".$type.".png";
    my $pltname = $file."_".$type.".plt";

    # and then plotting the stuff, using gnuplot!
    open FILE, ">$pltname" or die "can't open $pltname";
    print FILE<<EOF;
set terminal png size 1280,1024
set output '$pngname'
set multiplot layout 3, 1

set title "perfect sensor pressure according to calibration"
set xlabel "Rb in Ohm"
set ylabel "V_sens in mV"
set zlabel "Rbdot in Ohm"
splot '$datname' using 1:2:3 with lines

f(x) = m*x + b
fit f(x) '$datname' using 1:3 via m,b
set title "only linear fit using only Rb"
set xlabel "Rb in Ohm"
set ylabel "Rbdot in Ohm"
plot '$datname' using 1:3 with points title '', \\
     f(x) title sprintf("Rbdot(Rb) = %3.4f + %3.4f*V_sens",b,m)

set title "absolute error"
set xlabel "Rb in Ohm"
set ylabel "Rbdot in Ohm"
plot '$datname' using 2:(f(\$2)-\$3) with points title ''

EOF
    close FILE;

    system("gnuplot $pltname 2&>1 /dev/null");
}
sub plotP {
    my $file = shift;
    my $type = shift;
    my $datname = $file."_".$type.".dat";
    my $pngname = $file."_".$type.".png";
    my $pltname = $file."_".$type.".plt";

    # and then plotting the stuff, using gnuplot!
    open FILE, ">$pltname" or die "can't open $pltname";
    print FILE<<EOF;
set terminal png size 1280,1024
set output '$pngname'
set multiplot layout 3, 1

set title "perfect sensor pressure according to calibration"
set xlabel "Rb in Ohm"
set ylabel "V_sens in mV"
set zlabel "P in Bar"
splot '$datname' using 1:2:3 with lines

f(x) = m*x + b
fit f(x) '$datname' using 2:3 via m,b
set title "only linear fit using only V_sens"
set xlabel "V_sens in mV"
set ylabel "P in Bar"
plot '$datname' using 2:3 with points title '', \\
     f(x) title sprintf("P(V_sens) = %3.4f + %3.4f*V_sens",b,m)

set title "absolute error of linear fit against perfect calibration"
set xlabel "V_sens in mV"
set ylabel "P in Bar"
set cblabel "Rb in Ohm"
set palette model RGB defined (3300 'red', 3800 'green')
plot '$datname' using 2:(f(\$2)-\$3):1 with points palette title 'absolute error in Bar'

EOF
    close FILE;

    system("gnuplot $pltname 2&>1 /dev/null");
}
sub plotT {
    my $file = shift;
    my $type = shift;
    my $datname = $file."_".$type.".dat";
    my $pngname = $file."_".$type.".png";
    my $pltname = $file."_".$type.".plt";

    # and then plotting the stuff, using gnuplot!
    open FILE, ">$pltname" or die "can't open $pltname";
    print FILE<<EOF;
set terminal png size 1280,1024
set output '$pngname'
set multiplot layout 3, 1

set title "perfect sensor pressure according to calibration"
set xlabel "Rb in Ohm"
set ylabel "V_sens in mV"
set zlabel "T in °C"
splot '$datname' using 1:2:3 with lines

f(x) = m*x + b
fit f(x) '$datname' using 1:3 via m,b
set title "only linear fit using only Rb"
set xlabel "Rb in Ohm"
set ylabel "T in °C"
plot '$datname' using 1:3 with points title '', \\
     f(x) title sprintf("R(Rb) = %3.4f + %3.4f*V_sens",b,m)

set title "absolute error"
set xlabel "Rb in Ohm"
set ylabel "T in °C"
plot '$datname' using 1:(f(\$1)-\$3) with points title ''

EOF
    close FILE;

    system("gnuplot $pltname 2&>1 /dev/null");
}


# get a list of all "*.TXT" files in the directory
# named by the first argument
my $dir = shift;
# conditionally add slash at the end, if there is none (i like perl)
$dir .= '/' unless $dir =~ m(/$);
opendir (DIR, $dir) or die $!;
while (my $file = readdir(DIR)) {
    # skip non-TXT files
    next if $file !~ /\.TXT/;

    # declare some vars
    my $cal;
    my $Rbdot;
    my $P;
    my $T;

    # create the calibration object
    $cal = new KellerPressureSensorCalibrator($dir . $file);

    # create a file to store the results
    open FILE_Rbdot, ">$file"."_Rbdot.dat" or die "failed to open file";
    open FILE_P, ">$file"."_P.dat" or die "failed to open file";
    open FILE_T, ">$file"."_T.dat" or die "failed to open file";

    # then iterate over all Rb and V_sens
    for (my $Rb = $Rb_min; $Rb < $Rb_max; $Rb=$Rb+$Rb_stepsize)
    {

        for (my $V_sens = $V_sens_min; $V_sens < $V_sens_max; $V_sens=$V_sens+$V_sens_stepsize)
        {

            # get the calibrated values for Rbdot, P and T
            # and write the result to the *.dat file
            $Rbdot = $cal->getRbdot($Rb,$V_sens);
            print FILE_Rbdot $Rb." ".$V_sens." ".$Rbdot."\n";

            $P = $cal->getP($Rb,$V_sens);
            print FILE_P $Rb." ".$V_sens." ".$P."\n";

            $T = $cal->getT($Rb,$V_sens);
            print FILE_T $Rb." ".$V_sens." ".$T."\n";

        }
    }

    close FILE_Rbdot or die "failed to close file";
    close FILE_P or die "failed to close file";
    close FILE_T or die "failed to close file";

    plotRbdot($file, "Rbdot");
    plotP($file, "P");
    plotT($file, "T");

    #exit;
}

closedir(DIR);
