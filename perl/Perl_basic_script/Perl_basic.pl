#!/usr/bin/perl
# http://perldoc.perl.org/perlintro.html
use strict;
use warnings;

# Print
my $NAME = "camel"; # Lokale Variable -> Gute Programmierpraxis
# $NAME2 = "camel"; # Globale Variable -> Schlechte Programmierpraxis

# This is a comment
print "Hello, world \n";
print "Hello, world \n";
print 'Hello, world \n';
print "Hello, $NAME\n";     # works fine
print 'Hello, $NAME\n';     # prints $name\n literally
print "\n" , 42 , "\n";

# Arrays
my @animals = ("camel", "llama", "owl");
my @numbers = (23, 42, 69);
my @mixed   = ("camel", 42, 1.23);

print $animals[0], "\n";              # prints "camel"
print $animals[1], "\n";              # prints "llama"
print $#animals + 1 ,  "\n";          # tells how many items there are in an array

if (@animals < 5) { print "Last element: ", $animals[$#animals], "\n"};

@animals[0,1];                  # gives ("camel", "llama");
@animals[0..2];                 # gives ("camel", "llama", "owl");
@animals[1..$#animals];         # gives all except the first element

my @sorted    = sort @animals;
my @backwards = reverse @numbers;

print @sorted[0..$#sorted], "\n";

# Hashes
#A hash represents a set of key/value pairs:
my %fruit_color = ("apple", "red", "banana", "yellow");
# or:
my %fruit_colors = (
       apple  => "red",
       banana => "yellow",
   );

print $fruit_color{"apple"} , "\n";           # gives "red"


#You can get at lists of keys and values with keys() and values().
my @fruits = keys %fruit_color;
my @colors = values %fruit_color;

my $variables = {
    scalar  =>  {
                 description => "single item",
                 sigil => '$',
                },
    array   =>  {
                 description => "ordered list of items",
                 sigil => '@',
                },
    hash    =>  {
                 description => "key/value pairs",
                 sigil => '%',
                },
};

print "Scalars begin with a $variables->{'scalar'}->{'sigil'}\n";


#Conditional and looping constructs
if ( 1 == 1 ) {
  print "1 == 1";
} elsif ( 1 == 1 ) {
    
} else {
   
}

unless ( 1 == 1 ) {
  print "1 == 1";

}

# the traditional way
if ($animals[0]) {
    print "Yow!";
}

# the Perlish post-condition way
print "Yow!" if $animals[0];
print "We have no bananas" unless $animals[0];

while ( 1==2 ) {

}


until ( 1 ==1 ) {
}

print "LA LA LA\n" while 1==2;          # loops forever

for (my $i = 0; $i <= 5; $i++) {
    print "...\n";
}

foreach (@animals) {
    print "This element is $_\n";
}

print $animals[$_], "\n" foreach 0 .. 2;

my $a += 1;        # same as $a = $a + 1
my $b -= 1;        # same as $a = $a - 1
my $c .= "\n";     # same as $a = $a . "\n";

open(my $in,  "<",  "input.txt")  or die "Can't open input.txt: $!";
open(my $out, ">",  "output.txt") or die "Can't open output.txt: $!";
open(my $log, ">>", "my.log")     or die "Can't open my.log: $!";

my $line  = <$in>;
my @lines = <$in>;

while (<$in>) {     # assigns each line in turn to $_
    print "Just read in this line: $_";
}

print STDERR "This is your final warning.\n";
close $in or die "$in: $!";

if ($a =~ /foo/) { print"Test\n" }  # true if $a contains "foo"

# Subroutines

sub logger {
    my $logmessage = shift;
    open my $logfile, ">>", "my.log" or die "Could not open my.log: $!";
    print $logfile $logmessage;
}

sub square {
    my $num = shift;
    my $result = $num * $num;
	#print $result, "\n";
    return $result;
}

print square(8), "\n";
my $sq = square(8), "\n";

logger("We have a logger subroutine!");
















