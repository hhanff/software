#!/usr/bin/perl
use strict;
use warnings;

#A scalar represents a single value:
my $name = "Hendrik";
print "Hello, $name\n"; # works fine
print 'Hello, $name\n'; # prints $name\n literally

my $answer = 42;
print "\nMy answer: $answer\n";

my $animal = "camel";
print $animal;
print "\nThe animal is $animal\n";
print "The square of $answer is ", $answer * $answer, "\n";

print;          # prints contents of $_ by default

# An array represents a list of values:

my @animals = ("camel", "llama", "owl");
my @numbers = (23, 42, 69);
my @mixed = ("camel", 42, 1.23);

# Arrays are zero-indexed. Here's how you get at elements in an array:

print "\n$animals[0]"; # prints "camel"
print "\n$animals[1]"; # prints "llama"

# The special variable $#array tells you the index of the last element of an array:

print "\n$mixed[$#mixed]"; # last element, prints 1.23

# You might be tempted to use $#array + 1 to tell you how many items there are in an array. Don't bother. As it happens, using @array where Perl expects to find a scalar value ("in scalar context") will give you the number of elements in the array:

#if (@animals < 5) { }

# The elements we're getting from the array start with a $ because we're getting just a single value out of the array; you ask for a scalar, you get a scalar.
# To get multiple values from an array:

print "\n@animals[0,1]"; # gives ("camel", "llama");
print "\n@animals[0..2]"; # gives ("camel", "llama", "owl");
print "\n@animals[1..$#animals]"; # gives all except the first element

# This is called an "array slice".
# You can do various useful things to lists:

my @sorted = sort @animals;
my @backwards = reverse @numbers;

# There are a couple of special arrays too, such as @ARGV (the command line arguments to your script) and @_ (the arguments passed to a subroutine). These are documented in perlvar.
# Hashes
# A hash represents a set of key/value pairs:

#my %fruit_color = ("apple", "red", "banana", "yellow");

# You can use whitespace and the => operator to lay them out more nicely:

my %fruit_color = (
    apple => "red",
    banana => "yellow",
    );

# To get at hash elements:

print "\n$fruit_color{\"apple\"}"; # gives "red"

# You can get at lists of keys and values with keys() and values().

# my @fruits = keys %fruit_colors;
# my @colors = values %fruit_colors;

# Hashes have no particular internal order, though you can sort the keys and loop through them.
# Just like special scalars and arrays, there are also special hashes. The most well known of these is %ENV which contains environment variables. Read all about it (and other special variables) in perlvar.
# Scalars, arrays and hashes are documented more fully in perldata.
# More complex data types can be constructed using references, which allow you to build lists and hashes within lists and hashes.
# A reference is a scalar value and can refer to any other Perl data type. So by storing a reference as the value of an array or hash element, you can easily create lists and hashes within lists and hashes. The following example shows a 2 level hash of hash structure using anonymous hash references.

my $variables = {
    scalar => {
	description => "single item",
	sigil => '$',
    },
    array => {
	description => "ordered list of items",
	sigil => '@',
    },
    hash => {
	description => "key/value pairs",
	sigil => '%',
    },
};

print "\nScalars begin with a $variables->{'scalar'}->{'sigil'}\n";

# Exhaustive information on the topic of references can be found in perlreftut, perllol, perlref and perldsc.
