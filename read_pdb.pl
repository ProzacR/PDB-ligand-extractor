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
#print Dumper \@lines;


#split lines into symbols
$x=0;
while ($lines[$x]) {
push @{$atoms[$x]}, split(//, $lines[$x]);;
$x++;
}
#print Dumper \@atoms;


#make formated hash:
$x = 0;
while($atoms[$x]) {
#COLUMNS        DATA TYPE       CONTENTS                            
#--------------------------------------------------------------------------------
# 1 -  6        Record name     "ATOM  "                                            
$atom[$x]{'record'} = join "", @{$atoms[$x]}[0..5];
print $atom[$x]{'record'}, "\n";

# 7 - 11        Integer         Atom serial number.                   

#13 - 16        Atom            Atom name.                            

#17             Character       Alternate location indicator.         

#18 - 20        Residue name    Residue name.                         

#22             Character       Chain identifier.                     

#23 - 26        Integer         Residue sequence number.              

#27             AChar           Code for insertion of residues.       

#31 - 38        Real(8.3)       Orthogonal coordinates for X in Angstroms.                       

#39 - 46        Real(8.3)       Orthogonal coordinates for Y in Angstroms.                            

#47 - 54        Real(8.3)       Orthogonal coordinates for Z in Angstroms.                            

#55 - 60        Real(6.2)       Occupancy.                            

#61 - 66        Real(6.2)       Temperature factor (Default = 0.0).                   

#73 - 76        LString(4)      Segment identifier, left-justified.   

#77 - 78        LString(2)      Element symbol, right-justified.      

#79 - 80        LString(2)      Charge on the atom.  

$x++;
}
