#!/usr/bin/perl
#
# simple pdb file reader
#
# VR

use warnings;
use Data::Dumper;


#take file name
if (@ARGV == 1) {
$file = $ARGV[0];
} else {
die("usage: read_pdb.pl file.pdb");
}


#read file into lines
open(INFO, $file) or die("Could not open  file.");
while(<INFO>) {
 push (@lines, $_) if (!index($_, "HETATM") || !index($_, "ATOM"));
}
close(INFO);
print Dumper \@lines;


#split lines into symbols
$x=0;
while ($lines[$x]) {
@temp = split(//, $lines[$x]);
#print Dumper \@temp;
push @{$atoms[$x]}, @temp;
$x++;
}
print Dumper \@atoms;



