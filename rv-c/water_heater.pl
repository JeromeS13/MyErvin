#!/usr/bin/perl -w
#
# Copyright (C) 2019 Wandertech LLC
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

use strict;
no strict 'refs';
use Switch;

our $debug = 0;

our %commands = (
    '108F' => '108F',
    '106F' => '106F',
    '104F' => '104F',
    '102F' => '102F',
    '100F' => '100F',
    '99F' => '99F',
    '97F' => '97F',
    '95F' => '95F',
    'off' => 'off',
);

our %water_heater_commands = (
    '108F' => 'C8026027FFFFFFFF',
    '106F' => 'C8024027FFFFFFFF',
    '104F' => 'C8022027FFFFFFFF',
    '102F' => 'C8020027FFFFFFFF',
    '100F' => 'C802E026FFFFFFFF',
    '99F' => 'C802C026FFFFFFFF',
    '97F' => 'C802A026FFFFFFFF',
    '95F' => 'C8028026FFFFFFFF',
    'off' => 'C8008026FFFFFFFF',);

if (scalar(@ARGV) < 1) {
    print "ERROR: Too few command line arguments provided.\n";
    usage();
}

our $command = $ARGV[0];
if (!exists($commands{$command})) {
    print "ERROR: Invalid command specified.\n";
    usage();
}

our ($prio, $dgnhi, $dgnlo, $srcAD) = (6, '1FF', 'F6', 99);

our $binCanId = sprintf("%b0%b%b%b", hex($prio), hex($dgnhi), hex($dgnlo), hex($                                                                                        srcAD));
our $hexCanId = sprintf("%08X", oct("0b$binCanId"));

our $hexData;

if ($water_heater_commands{$command}) {
    $hexData = $water_heater_commands{$command};
    cansend($hexCanId, $hexData);
}

exit;

sub cansend {
    our $debug;
    my ($id, $data) = @_;
    system('cansend can0 ' . $id . "#" . $data) if (!$debug);
    print 'cansend can0 '. $id . "#" . $data . "\n" if ($debug);
}

sub usage {
    print "Usage: \n";
    print "\t$0 <command>\n";
    print "\n\tCommands:\n";
    foreach my $key ( keys %commands ) {
        print "\t\t" . $key . " = " . $commands{$key} . "\n";
    }
    print "\n";
    exit(1);
}



