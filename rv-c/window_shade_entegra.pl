#!/usr/bin/perl -w
#
# Version 1.1 for ENTEGRA includes support for split passenger seat shades beginning in 2018.
#
# Copyright 2018 Wandertech LLC
# Entegra mods Copyright 2019 Rob Picchione 
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

use strict;
no strict 'refs';

our $debug = 0;

# A list of shade and awning commands. 'd' and 'n' indicate day or night shade IDs. Where a
# single value is present, a DC_DIMMER_COMMAND is used to toggle the shade. Where individual
# up ('u') and down ('d') values are present, a pair of WINDOW_SHADE_COMMANDs are used.
#
# [TIFFIN] See notes at bottom of file for conversion from old (pre-2.2.1) values to new (2.2.1+ values).
our %mappings=(
  # [ENTEGRA] Mappings for Entegra Anthem/Cornerstone at least 2015 and up. 
  # [ENTEGRA] Note: As of 20190108 2014 & older Entegra have not been tested, the below may work.
  1  => {'day' => 1,  'night' => 5},
  2  => {'day' => 2,  'night' => 6},
  3  => {'day' => 3,  'night' => 7},
  4  => {'day' => 4,  'night' => 8},
  5  => {'day' => 9,  'night' => 13},
  6  => {'day' => 10, 'night' => 14},
  7  => {'day' => 11, 'night' => 15},
  8  => {'day' => 12, 'night' => 16},
  9  => {'day' => 17, 'night' => 21},
  10 => {'day' => 18, 'night' => 22},
  11 => {'day' => 19, 'night' => 23},
  12 => {'day' => 20, 'night' => 24},
  13 => {'day' => 25, 'night' => 29},  
  14 => {'day' => 26, 'night' => 30},
  15 => {'day' => 27, 'night' => 31},
  16 => {'day' => 28, 'night' => 32},
  #
  # [ENTEGRA] Below Mapping for passenger seat window which was split into two shades (entry and window) 2018
  # and up. Below are the G6 instances on a 2018 Entegra Cornerstone DEQ, all the other shades have dedicated
  # shade control modules.
  #
  17 => {'day' => {'up' => [ 117,  118], 'down' => [ 118,  117]}, 'night' => {'up' => [ 119,  120], 'down' => [ 120,  119]}},
  #
  #
  # [TIFFIN] Mappings from the original coach proxy file for shades NOT controlled by an RV-C Shade control module.
    # 17 => {'day' => 0,                                          'night' => {'up' => [ 13,  15], 'down' => [ 15,  13]}},
    # 18 => {'day' => {'up' => [ 77,  78], 'down' => [ 78,  77]}, 'night' => {'up' => [ 79,  80], 'down' => [ 80,  79]}},
    # 19 => {'day' => {'up' => [ 81,  82], 'down' => [ 82,  81]}, 'night' => {'up' => [ 81,  82], 'down' => [ 82,  81]}},
    # 20 => {'day' => {'up' => [ 97,  98], 'down' => [ 98,  97]}, 'night' => {'up' => [ 99, 100], 'down' => [100,  99]}},
    # 21 => {'day' => 0,                                          'night' => {'up' => [101, 102], 'down' => [102, 101]}},
    # 22 => {'day' => {'up' => [122, 121], 'down' => [121, 122]}, 'night' => {'up' => [122, 121], 'down' => [121, 122]}},
    # 23 => {'day' => {'up' => [ 18,  17], 'down' => [ 17,  18]}, 'night' => 0},
    # 24 => {'day' => {'up' => [124, 123], 'down' => [123, 124]}, 'night' => {'up' => [124, 123], 'down' => [123, 124]}},
  # [TIFFIN] Special shades for Tiffin customer who added control module to his 2015 Allegro Bus 45 LP
    # 90 => {'day' => 18, 'night' => 19},  # Windshield
    # 91 => {'day' => 0,  'night' => 17},  # Passenger Seat
    # 92 => {'day' => 0,  'night' => 20},  # Driver Seat (pins swapped, up=down)
);

# Up/down options
our %ts=(
  'day'=>1, 'night'=>1
);

# Direction commands
our %ds = (
  'up' => 69, 'down' => 133
);

if ( scalar(@ARGV) < 4 ) {
  print "ERR: Insufficient command line data provided.\n";
  usage();
}

if(!exists($ts{$ARGV[1]})) {
  print "ERR: Shade Type does not exist.  Please see Type list below.\n";
  usage();
}

if(!exists($ds{$ARGV[2]})) {
  print "ERR: Direction not allowed.  Please see Direction list below.\n";
  usage();
}

if(!exists($mappings{$ARGV[3]})) {
  print "ERR: Shade Location does not exist.  Please see Location list below.\n";
  usage();
}

my ($year, $type, $dir) = (shift, shift, shift);

foreach my $loc (@ARGV) {
  shade($loc, $type, $dir);
}

exit;


sub shade {
  my ($loc,$type,$dir) = @_;
  our %ds;
  our %mappings;
  my ($prio,$dgnhi,$dgnlo,$srcAD)=(6,'1FE','DF',96);

  if (ref($mappings{$loc}{$type}) eq 'HASH') {
    $dgnlo='DB';
    my $binCanId=sprintf("%b0%b%b%b",hex($prio),hex($dgnhi),hex($dgnlo),hex($srcAD));
    my $hexCanId=sprintf("%08X",oct("0b$binCanId"));

    # Stop the 'Anti' Location
    my $hexData=sprintf("%02XFFC8%02X%02X00FFFF",$mappings{$loc}{$type}{$dir}[1],3,0);
    system('cansend can0 '.$hexCanId."#".$hexData) if(!$debug);
    print 'cansend can0 '.$hexCanId."#".$hexData."\n" if($debug);

    # Engage the Location
    $hexData=sprintf("%02XFFC8%02X%02X00FFFF",$mappings{$loc}{$type}{$dir}[0],5,30);
    system('cansend can0 '.$hexCanId."#".$hexData) if(!$debug);
    print 'cansend can0 '.$hexCanId."#".$hexData."\n" if($debug);

  } else {
    # Don't make an attempt if the shade ID is 0 (e.g. missing day shade).
    if ($mappings{$loc}{$type} > 0) {

      # 2015 an newer Entegra  uses reversed directions and different IDs. Also, Tiffin customer with custom
      # shades on 2015 Bus accidentally swapped directions on his custom shade #92.
      if ($year >= 2015 or $loc == 92) {
        %ds = ('up' => 133, 'down' => 69);
      }

      my $binCanId=sprintf("%b0%b%b%b",hex($prio),hex($dgnhi),hex($dgnlo),hex($srcAD));
      my $hexCanId=sprintf("%08X",oct("0b$binCanId"));
      my $hexData=sprintf("%02XFFC8%02X%02X00FFFF",$mappings{$loc}{$type},$ds{$dir},30);

      system('cansend can0 '.$hexCanId."#".$hexData) if(!$debug);
      print 'cansend can0 '.$hexCanId."#".$hexData."\n" if($debug);
    }
  }
}

sub usage {
  print "Usage: \n";
  print "\t$0 <year> <type> <direction> <location> ...\n";
  print "\n\t<type> is required and one of:\n";
  print "\t\tday, night\n";
  print "\n\t<direction> is required and one of:\n";
  print "\t\tup, down\n";
  print "\n\t<location> is required and one or more of:\n\t\t";
  foreach my $key ( sort {$a <=> $b} keys %mappings ) {
    print "$key "
  }
  print "\n";
  exit(1);
}
