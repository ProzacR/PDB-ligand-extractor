#!/usr/bin/perl
#VR
#take ligands from pdb and save into pdb

#here ignored ligands array
@ismesti = (HOH, HG, ZN, CO, CU, NI, SO3, SO4, DOD, CL, OH, CO2);

#main
$x=0;
while (@ARGV[$x]) {
open FILE, "<@ARGV[$x]" or die $!;
print "\nFrom ", @ARGV[$x], ":";
@lines = <FILE>;
selectligands();
close(FILE);
$x++;
}

sub selectligands {
$n=0;
$i=0;
while (@lines[$n]) {
  @eilute = split(' ', @lines[$n]);
  push(@eilute, "\n");
  if (($eilute[0] eq "HETATM") && !(grep {$_ eq $eilute[3]} @ismesti)) {
    if ($i == 0) {
      $paimtas_ligandas = $eilute[3];
    }
    if ($eilute[3] ne $paimtas_ligandas) {
      writepdb();
      $i = 0;
    }
    @HETATM[$i] = @lines[$n]; #join(' ', @eilute); Avogadro likes empty spaces
    $i++;
    } else {
     if ($i != 0) {
       writepdb();
     }
     $i = 0;
   }
  $n++;
}
@lines = '';
}

sub writepdb {
print " ", $paimtas_ligandas, ",";
$name = "${paimtas_ligandas}.pdb";
open (FILE, ">$name");
print FILE @HETATM;
close(FILE);
}
