#!/usr/bin/perl
#
#isimti ligandus is pdb ir isaugoti i pdb

#cia surasyti ligandus kuriuos ismesti
@ismesti = (HOH, HG);

#nuskaitom faila
open FILE, "<@ARGV[0]" or die $!;
my @lines = <FILE>;
close(FILE);

#atrenkam ko reikia
$n=0;
$i=0;
while (@lines[$n]) {
  @eilute = split(' ', @lines[$n]);
  push(@eilute, "\n");
  if (($eilute[0] eq "HETATM") && !(grep {$_ eq $eilute[3]} @ismesti)) {
    $i++;
    if (($eilute[3] ne $paimtas_ligandas) && ($i != 1)) {
    writepdb();
    $i = 0;
    }
    @HETATM[$i] = @lines[$n]; #join(' ', @eilute); Avogadro megsta tarpus
    $paimtas_ligandas = $eilute[3];
    }
  $n++;
}

#TODO: kolkas visus tinkamus suveda i viena faila, tai nelabai galima naudot *.pdb
sub writepdb {
print $paimtas_ligandas, "\n";
$name = "${paimtas_ligandas}.pdb";
open (FILE, ">$name");
print FILE @HETATM;
close(FILE);
}