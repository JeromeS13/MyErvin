//
// Copyright (C) 2019 Wandertech LLC
// Copyright (C) eRVin project mods 2020
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

// Input: the on/off or brightness payload from a light switch or slider.
// Output: command line parameters for the dc_dimmer.pl command to actuate the light.

var instance = msg.topic.split('_')[0];
var msgtype = msg.topic.split('_')[1];
var commands = { 'dim': 0, 'on': 2, 'off': 3 };

var command = commands['on'];

var space = ' ';

//var instancename = msg.topic.split('_')[2];
//global.set('status.lights[' + instance + '].instancename', instancename);


// eRVin mod: If below brightness value = 125 turning a dimmable light ON will revert to
// previous dim level, if = 100 turning light ON will force it to full brightness.
// This value can be set by the user in the dashboard Options.

var brightness = global.get ("options.onmode");
if (typeof brightness == 'undefined')
{
    brightness = 125
}


// eRVin mod: made changes to the below conditional so brightness value is not sent
// for an 'off' command.

if (msgtype == 'state') {
  command = commands[msg.payload];
  if (msg.payload == 'off') {
        space = '';
	brightness = ''
   }
} else if (msgtype == 'brightness') {
  brightness = msg.payload;
  if (brightness > 0) {
    command = commands['dim'];
  }
}

var newMsg={
  'payload': instance + ' ' + command + space + brightness
};

return newMsg;

