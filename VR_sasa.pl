#!/usr/bin/perl

# SASA using Shrake-Rupley algorithm
# calculate vapor to water free energy of transfer
# using Solvent Accessible Surface Area
# SASA
# VR 2013

use Math::Trig;
use Data::Dumper;


#Atomic radii
$radii{'H'}=1.20;
$radii{'C'}=1.70;
$radii{'N'}=1.55;
$radii{'O'}=1.52;


#solvation parameter
$solv_par{'H'}=0;
$solv_par{'C'}=27;
$solv_par{'N'}=-116;
$solv_par{'O'}=-116;


#H2O radius:
$prad=1.4;


##read pdb file
#take file name and solvation parameter try
if (@ARGV == 1) {
 $file = $ARGV[0];
 #$p = $ARGV[1]/10;
} else {
 die("usage: read_pdb.pl file.pdb (#(par)/10)");
}


#read file into lines
open(INFO, $file) or die("Could not open  file.");
while(<INFO>) {
 push (@lines, $_) if (!index($_, "HETATM") || !index($_, "ATOM"));
}
close(INFO);
#print STDERR Dumper \@lines;


#split lines into symbols
$x=0;
while ($lines[$x]) {
push @{$atoms[$x]}, split(//, $lines[$x]);;
$x++;
}
#print STDERR Dumper \@atoms;


#make formated hash:
$x = 0;
while($atoms[$x]) {
#COLUMNS        DATA TYPE       CONTENTS                            
#--------------------------------------------------------------------------------
# 1 -  6        Record name     "ATOM  "                                            
$atom[$x]{'record'} = join "", @{$atoms[$x]}[0..5];

# 7 - 11        Integer         Atom serial number.                   
$atom[$x]{'number'} = join "", @{$atoms[$x]}[6..10];

#13 - 16        Atom            Atom name.                            
$atom[$x]{'name'} = join "", @{$atoms[$x]}[12..15];

#17             Character       Alternate location indicator.         
$atom[$x]{'location'} = join "", @{$atoms[$x]}[16];

#18 - 20        Residue name    Residue name.                         
$atom[$x]{'resname'} = join "", @{$atoms[$x]}[17..19];

#22             Character       Chain identifier.                     
$atom[$x]{'chain'} = join "", @{$atoms[$x]}[21];

#23 - 26        Integer         Residue sequence number.              
$atom[$x]{'res_nr'} = join "", @{$atoms[$x]}[22..25];

#27             AChar           Code for insertion of residues.       
$atom[$x]{'ins_code'} = join "", @{$atoms[$x]}[26];

#31 - 38        Real(8.3)       Orthogonal coordinates for X in Angstroms.                       
$atom[$x]{'x'} = join "", @{$atoms[$x]}[30..37];

#39 - 46        Real(8.3)       Orthogonal coordinates for Y in Angstroms.                            
$atom[$x]{'y'} = join "", @{$atoms[$x]}[38..45];

#47 - 54        Real(8.3)       Orthogonal coordinates for Z in Angstroms.                            
$atom[$x]{'z'} = join "", @{$atoms[$x]}[46..53];

#55 - 60        Real(6.2)       Occupancy.                            
$atom[$x]{'occupancy'} = join "", @{$atoms[$x]}[54..59];

#61 - 66        Real(6.2)       Temperature factor (Default = 0.0).                   
$atom[$x]{'temp_factor'} = join "", @{$atoms[$x]}[60..65];

#73 - 76        LString(4)      Segment identifier, left-justified.   
$atom[$x]{'segment'} = join "", @{$atoms[$x]}[72..75];

#77 - 78        LString(2)      Element symbol, right-justified.      
$atom[$x]{'element'} = trim(join "", @{$atoms[$x]}[76..77]);

#79 - 80        LString(2)      Charge on the atom.  
$atom[$x]{'charge'} = join "", @{$atoms[$x]}[78..79];

$x++;
}
#print STDERR Dumper \@atom;


#tasku sk. aplink atomus (daugiau tiksliau: ~simtai):
$M=5000;

#atoms example 0,1,...  (x,y,z,radius,solvation parameter):
#@N[0] = [1,2,3,4,5];
#set atom new way, find radius
$x = 0;
while ($atom[$x]) {
$N[$x] = [$atom[$x]{'x'}, $atom[$x]{'y'}, $atom[$x]{'z'}, $radii{$atom[$x]{'element'}}, $solv_par{$atom[$x]{'element'}}];
$x++;
}
#print STDERR Dumper \@N;
#print STDERR $N[0][4];

$i = 0;
$irad = 0;

while(@N[$i]) {
 #print "skersmuo: ", $N[$i][3];
 $irad=$N[$i][3] + $prad;
 while ($k<$M) {
  $u=rand();
  $v=rand();
  $theta=2*pi*$u;
  $phi=acos(2*$v-1);
  $x=cos($theta)*sin($phi);
  $y=sin($theta)*sin($phi);
  $z=cos($phi);
  #sukuriamas taskas:
  $point[0]=$N[$i][0]+$x*$irad;
  $point[1]=$N[$i][1]+$y*$irad;
  $point[2]=$N[$i][2]+$z*$irad;
  push @{$pts[$i][$k]}, @point;
 $k++;
 }
$i++;
$k = 0;
}

#tasku visuma:
#print STDERR Dumper \@pts;

#eit per atomus ir istrinti taskus kurie kito atomo kelyje:
$i = 0;
$k = 0;

while(@N[$i]) {
 $irad=$N[$i][3] + $prad;
 $Mp=$M;
 while ($k<$M) {
  $fail=0;
  $j=$i+1; #strange here...sometimes jumps over next while at all!!?
  while(@N[$j]) {
   $jrad=$N[$j][3] + $prad;
   $r=sqrt(( ($pts[$i][$k][0]-$N[$j][0])+($pts[$i][$k][1]-$N[$j][1])+($pts[$i][$k][2]-$N[$j][2]) )**2);
   if($r <= $jrad) {
    $fail=1;
   }
   $j++;
  }
  if($fail) {
   $Mp--;
  }
 $k++;
 }
 #SASA atomu i:
 $sasa[$i]=4*pi*$irad*$irad*$Mp/$M;
$i++;
$k = 0;
}
#print STDERR "sasa: \n";
#print STDERR Dumper \@sasa;


#solvation energy:
$x=0;
while (@sasa >= $x) {
$E=$E+$sasa[$x]*$N[$x][4];
$x++;
}
#print STDERR "x: ", $x, "\n";
print "solvation energy: ";
print $E/1000;
print " kcal/mol\n";


# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
	my $string = shift;
	$string =~ s/^\s+//;
	$string =~ s/\s+$//;
	return $string;
}
