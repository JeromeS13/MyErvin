//
// Copyright (C) 2019 Wandertech LLC
//
// Modifications (C) 2020 Rob Picchione c/o The ERVIN Project
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// Input: the on/off or brightness payload from a light relay switch (no dim),
// or light dimmer switch/slider.
// Output: command line parameters for the dc_dimmer.pl command to actuate the light.
//
// Compatible with both the 'decode_dc_dimmer_light_ervin' & 'decode_dc_relay_light_ervin' Function Nodes
//
let instance = msg.topic.split('_')[0];
let msgtype = msg.topic.split('_')[1];
let commands = { 'dim': 0, 'on': 2, 'off': 3 };
let space = ' '

let command = commands['on'];

// If below brightness value = 125 turning a light ON will revert to previous dim level
let brightness = 125;
// if above brightness value = 100 turning light ON will force to full brightness


if (msgtype == 'relay') {
    command = commands[msg.payload] ;
    space = '' ;
    brightness = '' ;
    if (msg.payload == "on") {
   	space = ' ' ;
	brightness = 100 ;

} else if (msgtype == 'dimmer') {
    command = commands[msg.payload] ;
    if (msg.payload == 'off') {
        space = '' ;
        brightness = '' ;
    }
} else if (msgtype == 'brightness') {
  brightness = msg.payload ;
    if (brightness > 0) {
    command = commands['dim'] ;
    }
}

let msg1={
  'payload': instance + ' ' + command + space + brightness
};

return [ msg1 ];

