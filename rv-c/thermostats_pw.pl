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
    '70F' => '70F',
    '69F' => '69F',
    '68F' => '68F',
    '67F' => '67F',
    '66F' => '66F',
    '65F' => '65F',
    '64F' => '64F',
    '63F' => '63F',
    '62F' => '62F',
    '61F' => '61F',
    '60F' => '60F',
    'off' => 'off',
    'on' => 'on'
);

our %thermostat_commands = (
    '70F' => '00FFFFFFFFC224FF',
    '69F' => '00FFFFFFFFB024FF',
    '68F' => '00FFFFFFFF9E24FF',
    '67F' => '00FFFFFFFF8C24FF',
    '66F' => '00FFFFFFFF7B24FF',
    '65F' => '00FFFFFFFF6924FF',
    '64F' => '00FFFFFFFF5724FF',
    '63F' => '00FFFFFFFF4524FF',
    '62F' => '00FFFFFFFF3324FF',
    '61F' => '00FFFFFFFF2224FF',
    '60F' => '00FFFFFFFF1024FF',
    'off' => '00C0FFFFFFFFFFFF',
    'on' => '00C2FFFFFFFFFFFF');

if (scalar(@ARGV) < 1) {
    print "ERROR: Too few command line arguments provided.\n";
    usage();
}

our $command = $ARGV[0];
if (!exists($commands{$command})) {
    print "ERROR: Invalid command specified.\n";
    usage();
}

our ($prio, $dgnhi, $dgnlo, $srcAD) = (6, '1FE', 'F9', 99);

our $binCanId = sprintf("%b0%b%b%b", hex($prio), hex($dgnhi), hex($dgnlo), hex($                                                                                        srcAD));
our $hexCanId = sprintf("%08X", oct("0b$binCanId"));

our $hexData;

if ($thermostat_commands{$command}) {
    $hexData = $thermostat_commands{$command};
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



