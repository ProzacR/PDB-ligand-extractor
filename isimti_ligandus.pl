#!/usr/bin/env perl
#VR
#take ligands from pdb and save into pdb
#with PerlMol

use Chemistry::MacroMol;
use Chemistry::File::PDB;

#aminor. t.t.
@ismesti = (" ZN", " HG", DMS, HOH, SCN, SO3, SO4, DOD, H2S,
NO3, " XE", " RU", "3CO", AZI, CCN, CMH, CNN, HGB, UNX, MBO,
MMC, AUC, IOD, GOL, BE7, BCT, ACE, ACT, EDO, TRS, OXY,
#organomet:
B30, AMS, BON,
#kt.:
" BR", " CL", " CO", CO2, " CU", " MN", " NA", " NI", " OH",
#a.r.:
TRP, GLY, TYR, LYS, HIS, PRO, GLU, ASN, ASP, PHE, ILE, ALA,
ARG, ASP, SER, ASN, VAL, GLN, THR, LEU, CYS, MET);

if(!-d "ligandai") {
mkdir("ligandai", 0777);
}

#main
$x=0;
while (@ARGV[$x]) {
$macromol = Chemistry::MacroMol->read("@ARGV[$x]") or die $!;
print "\nFrom ", @ARGV[$x], ": ";
selectligands();
$x++;
}

sub selectligands {
@all_domains = $macromol->domains;
$n = 0;

#visus domenus reikia isnagrineti ir rasti ka imti ka ne
while (@all_domains[$n]) {
$tipas = @all_domains[$n]->type;
if (!(grep {$_ eq $tipas} @ismesti)) {
#taip galima israsyti ka reikia
print $tipas, "_", $n, " ";
@all_domains[$n]->write("ligandai/${tipas}_${x}_${n}.pdb", noid => 1);
}
$n++;
}
print "\n";
}