//
// Enter a "case" block below for each light in your Alexa Home network.
// The 'name' of the light MUST exactly equal the Alexa Home node name - upper/lower case matters!
// The loadId is the 'instance' number of the light - it is marked on your Firefly front panel.
// Be sure to accurately indicate if the light is dimmable - 'yes' or 'no'- if not sure enter 'no'.
// !!!!!WARNING!!!!!: Dimming Relay channels will damage your firefly panel!!!!!
// Note: It is possible that some Dimmer channels power LED fixtures that are not dimmable.
//       This should not hurt the light or firefly panel but the light may behave eratically.
//       In these cases set the dammable value to 'no'.
//
//Object values passed from the Alexa Home node:
// "msg.on" is true for on, false for off
// "msg.on_off_command" is true for on AND off and false for brightness change
// "msg.bri" is the brightness value between 1 and 100 
// msg.device_name is the name of the Alexa Node Device
// dimmable - for each light in the case list below set dimmable to "no" or "yes"
// dimmable = "no" by default - RELAY CIRCUITS MUST NOT BE DIMMED!!!

let loadId
let toggle = 125
let noToggle = 100
let onCommand = 0
let offCommand = 3
let payload
let dimmable = "no"


switch (msg.device_name) {
    //Enter a case block like the below for each Alexa Home node:
    case "All Lights":
    loadId = 0;
    dimmable = "no";
    break;
    //Enter a case block like the above for each Alexa Home node:
    
    case "Rear Bath Light":
    loadId = 13;
    dimmable = "yes";
    break;
    
    case "Rear Lav Light":
    loadId = 14;
    dimmable = "yes";
    break;
    
    case "Rear Bath Accent":
    loadId = 16;
    dimmable = "yes";
    break;
    
    case "Bedroom Ceiling Light":
    loadId = 17;
    dimmable = "yes";
    break;
    
    case "Over Bed Lights":
    loadId = 18;
    dimmable = "yes";
    break;
    
    case "Bedroom Accent":
    loadId = 19;
    dimmable = "yes";
    break;
    
    case "Bedroom Vanity":
    loadId = 20;
    dimmable = "yes";
    break;
    
    case "Bedroom Courtesy Light":
    loadId = 21;
    dimmable = "yes";
    break;
    
    case "Mid Bath Light":
    loadId = 22;
    dimmable = "yes";
    break;
    
    case "Mid Bath Accent":
    loadId = 23;
    dimmable = "yes";
    break;
    
    case "Entry Ceiling":
    loadId = 24;
    dimmable = "yes";
    break;
    
    case "Center Ceiling":
    loadId = 25;
    dimmable = "yes";
    break;
    
    case "Ceiling Accent":
    loadId = 26;
    dimmable = "yes";
    break;
    
    case "Living Room Accent":
    loadId = 27;
    dimmable = "yes";
    break;
    
    case "Sofa Lights":
    loadId = 29;
    dimmable = "yes";
    break;
    
    case 'Port Side Lights':
    loadId = 30;
    dimmable = "yes";
    break;
    
    case 'Starboard Side Lights':
    loadId = 31;
    dimmable = "yes";
    break;
    
    case 'Small Dinette Lights':
    loadId = 32;
    dimmable = "yes";
    break;
    
    case "Dinette Light":
    loadId = 33;
    dimmable = "yes";
    break;
    
    case 'Sink Light':
    loadId = 34;
    dimmable = "yes";
    break;
    
    case 'Hall Light':
    loadId = 35;
    dimmable = "yes";
    break;
    
    case "Under Slideout Lights":
    loadId = 37;
    dimmable = "no";
    break;
    
    case 'Port Awning Lights':
    loadId = 38;
    dimmable = "no";
    break;
    
    case 'Starboard Awning Lights':
    loadId = 39;
    dimmable = "no";
    break;
    
    case "Porch Light":
    loadId = 42;
    dimmable = "no";
    break;
    
    case 'Cargo Lights':
    loadId = 43;
    dimmable = "no";
    break;
    
    case 'Port Security Light':
    loadId = 44;
    dimmable = "no";
    break;
    
    case "Starboard Security Light":
    loadId = 45;
    dimmable = "no";
    break;
    
    case 'Motion Lights':
    loadId = 46;
    dimmable = "no";
    break;
    
    default:
}

    //Active for non-dimmable (relay) ON instances:
if (msg.on === true  && msg.on_off_command === true && dimmable === 'no' )  {
    onCommand = 2
    payload = loadId + " " + onCommand ;
}
    //Active for dimmable ON instances - revert to previous brightness setting:
if (msg.on === true && msg.bri > 0 && msg.on_off_command === true && dimmable === "yes") {
    payload = loadId + " " + onCommand + " " + toggle ; //Change Toggle to noToggle if full brightness desired with ON
}
    //Active if try to dim relay instances:
if (msg.on === true && msg.bri > 0 && msg.on_off_command === false && dimmable === "no")  {
    onCommand = 2
    payload = loadId + " " + onCommand ;
    node.warn ("Cannot DIM Relay Channels") ; // do not dim relay circuits!
}  
    //Active when brightness value sent for dimmable instances
if (msg.on === true && msg.bri > 0 && msg.on_off_command === false && dimmable === "yes") {
    payload = loadId + " " + onCommand + " " + msg.bri ;
}
    //Acitve for all OFF instances
if (msg.on === false)  {
    payload = loadId + " " + offCommand ;
}

let msg1 = {
     payload
  };


  return [ msg1 ];
  
  