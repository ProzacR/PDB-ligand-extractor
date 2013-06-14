#!/usr/bin/perl
#
# try to get Kd from pdb.org using id
#
# VR

use warnings;

die('usage: ./get_Kd.pl id') if (@ARGV != 1);
my $id = $ARGV[0];


my $url = 'http://pdb.org/pdb/explore/explore.do?structureId=' . $id;

use LWP::Simple;
my $content = get $url;
die "Couldn't get $url" unless defined $content;
@lines = split(/\n/, $content);
foreach(@lines) {
  if($_ =~ m/Kd\:/i) {
    @data = split(/>|</, $_);
    last;
  }
}


#foreach (@data) {
#print "$_\n";
#}

print $id,",",$data[4],",",$data[10],"\n";
