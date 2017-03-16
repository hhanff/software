#!/usr/bin/perl

use strict;
use warnings;

# in perl, packages in extra files are coresponding to classes
package KellerPressureSensorCalibrator;

sub new
{
    my $class = shift;
    my $file = shift;
    # a new sensor has a calibration file (which we need to parse lateron)
    my $self = {
        Rbdot => {},
        P => {},
        T => {},
    };

    print "New $class with calibration $file\n";

    # parsing of file
    open FILE, $file or die "can't open $file\n";
    my @lines = <FILE>;

    # the rx for the Rbdot/T: "[a-d]\s+(-?\d+\.\d+E[+-]\d+)"
    # the rx for the P: "[a-d][0-3]\s+(-?\d+\.\d+E[+-]\d+)"
    my $cnt = 0;
    for my $line (@lines) {
        # tries to match the Rbdot/T term, hard: first four are
        # Rbdot, second four are T
        if ($line =~ /([a-d])\s+(-?\d+\.\d+E[+-]\d+)/)
        {
            if ($cnt<4)
            {
                $self->{Rbdot}{ $1 } = $2;
                #print "got Rbdot " . $1 . " and " . $2 . "\n";
            }
            else
            {
                $self->{T}{ $1 } = $2;
                #print "got T " . $1 . " and " . $2 . "\n";
            }

            $cnt = $cnt+1;
        }

        # tries to match for the P coeffs (easy, 16 to be added)
        if ($line =~ /([a-d][0-3])\s+(-?\d+\.\d+E[+-]\d+)/)
        {
            #print "got P " . $1 . " and " . $2 . "\n";
            $self->{P}{ $1 } = $2;
        }

    }

    # check if we got somethin'
    if ( keys(%{$self->{Rbdot}}) != 4 ) {
        die "no matches for Rbdot in $file found";
    }
    if ( keys(%{$self->{P}}) != 16 ) {
        die "no matches for P in $file found";
    }
    if ( keys(%{$self->{T}}) != 4 ) {
        die "no matches for T in $file found";
    }

    #while ( my ($key, $value) = each(%{$self->{Rbdot}}) ) {
    #    print "$key => $value\n";
    #}

    close FILE or die "can't close file\n";

    bless $self, $class;
    return $self;
}


# access stored variables in array of object, and multiply them by arguments
# Rbdot = Rb -(a +b*Sig +c*Sig^2 +... )
sub getRbdot
{
    my( $self ) = @_;
    my $Rb = $_[1];
    my $V_sens = $_[2];

    my %hash = %{$self->{Rbdot}};
    my $retval = $Rb +
                 $hash{'a'} +
                 $hash{'b'} * $V_sens +
                 $hash{'c'} * $V_sens * $V_sens +
                 $hash{'d'} * $V_sens * $V_sens * $V_sens;

    return $retval;
}

#P = f(Sig,Rb')
#    P = a  +b*Sig +c*Sig^2 +...
#    a = a0 +a1*Rb' +a2*Rb'^2  +...
#    b = b0 +b1*Rb' +b2*Rb'^2  +...
#    c = .....
sub getP
{
    my( $self ) = @_;
    my $Rb = $_[1];
    my $V_sens = $_[2];

    # call ourself
    my $Rbdot = $self->getRbdot($Rb, $V_sens);

    my %hash = %{$self->{P}};
    my $a =  $hash{'a0'} +
             $hash{'a1'} * $Rbdot + 
             $hash{'a2'} * $Rbdot * $Rbdot + 
             $hash{'a3'} * $Rbdot * $Rbdot * $Rbdot;
    my $b =  $hash{'b0'} +
             $hash{'b1'} * $Rbdot + 
             $hash{'b2'} * $Rbdot * $Rbdot + 
             $hash{'b3'} * $Rbdot * $Rbdot * $Rbdot;
    my $c =  $hash{'c0'} +
             $hash{'c1'} * $Rbdot + 
             $hash{'c2'} * $Rbdot * $Rbdot + 
             $hash{'c3'} * $Rbdot * $Rbdot * $Rbdot;
    my $d =  $hash{'d0'} +
             $hash{'d1'} * $Rbdot + 
             $hash{'d2'} * $Rbdot * $Rbdot + 
             $hash{'d3'} * $Rbdot * $Rbdot * $Rbdot;

    # P = a  +b*Sig +c*Sig^2 +...
    my $retval = $a +
                 $b * $V_sens +
                 $c * $V_sens * $V_sens +
                 $d * $V_sens * $V_sens * $V_sens;

    return $retval;
}

# T = a  +b*Rb' +c*Rb'^2 +...
sub getT
{
    my( $self ) = @_;
    my $Rb = $_[1];
    my $V_sens = $_[2];

    # call ourself
    my $Rbdot = $self->getRbdot($Rb, $V_sens);

    my %hash = %{$self->{T}};
    my $retval =  $hash{'a'} +
                  $hash{'b'} * $Rbdot + 
                  $hash{'c'} * $Rbdot * $Rbdot + 
                  $hash{'d'} * $Rbdot * $Rbdot * $Rbdot;

    return $retval;
}

# get the pair of linear coefficients of a specific type
# get the first one for a given bitwidth
# get the second one rounded to a power of two for better vhdl performance
sub getLinearCoeff {
    my( $self ) = @_;
    my $type = $_[1];

}

# don't what the heck this is for: 
# (maybe to tell someone, if something went wrong...)
1;
