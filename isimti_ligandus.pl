#!/usr/bin/perl
#VR
#take ligands from pdb and save into pdb

#here ignored ligands array
@ismesti = (HOH, HG, ZN);

#read file
open FILE, "<@ARGV[0]" or die $!;
my @lines = <FILE>;
close(FILE);

#select ligands
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

sub writepdb {
print $paimtas_ligandas, "\n";
$name = "${paimtas_ligandas}.pdb";
open (FILE, ">$name");
print FILE @HETATM;
close(FILE);
}
