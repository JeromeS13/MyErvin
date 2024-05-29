node-red-contrib-suncalcinput
=====================

A <a href="http://nodered.org" target="_new">Node-RED</a> node to provide a signal at sunrise and sunset. Where location can be changed with the input.

Install
-------

Run the following command in your Node-RED user directory - typically `~/.node-red`

    npm install node-red-contrib-suncalcinput


Usage
-----

Uses the suncalc npm to generate an output at sunrise and sunset based on a specified location.

Several choices of definition of sunrise and sunset are available, see the
<i><a href = "https://github.com/mourner/suncalc" target="_new">suncalc</a></i> module for details.

The node provide two outputs. The first output emits a `msg.payload` of <i>1</i> or <i>0</i> every minute
depending if day-time (1) or night-time (0).

The second output emits only on the transition between night to day (<i>-> 1</i>) or day to night (<i>-> 0</i>).

It also sets the `msg.topic` to <i>sun</i> and `msg.moon` to the fraction of the moon currently visible
(a value between 0 for no moon and 1 for full moon).</p>

The node provide one input. Setting `msg.lat` to latitude and `msg.lon` to longitude will change the position.

Acknowledgement
---------------

This node is based on <a href="https://github.com/node-red/node-red-nodes/tree/master/time/suncalc" target="_new">node-red-node-suncalc</a> which offers the same functionality except for the posibility to change position dynamically.