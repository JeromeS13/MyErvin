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
    'up' => 'Fan Up',
    'down' => 'Fan Down',
    'fan_on' => 'Fan On (100%)',
    'decrease_speed' => 'Decrease Fan Speed',
    'increase_speed' => 'Increase Fan Speed',
    'fan_off' => 'Fan Off',
);

our %vent_fan_commands = (
    'up' => '510001C8FFFFFFFF',
    'down' => '510002FFC8FFFFFF',
    'fan_on' => '5101FFFFFFFFFFFF',
    'decrease_speed' => '51FFFFFFFCFFFFFF',
    'increase_speed' => '51FFFFFFFBFFFFFF',
    'fan_off' => '5100FFFFFFFFFFFF',
);

if (scalar(@ARGV) < 1) {
    print "ERROR: Too few command line arguments provided.\n";
    usage();
}

our $command = $ARGV[0];
if (!exists($commands{$command})) {
    print "ERROR: Invalid command specified.\n";
    usage();
}

our ($prio, $dgnhi, $dgnlo, $srcAD) = (6, '1FF', 'E0', 99);

our $binCanId = sprintf("%b0%b%b%b", hex($prio), hex($dgnhi), hex($dgnlo), hex($srcAD));
our $hexCanId = sprintf("%08X", oct("0b$binCanId"));

our $hexData;

if ($vent_fan_commands{$command}) {
    $hexData = $vent_fan_commands{$command};
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

