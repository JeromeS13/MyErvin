module.exports = function(RED) {
  function SimpleSendmail(config) {
    var nodemailer = require("nodemailer");
    RED.nodes.createNode(this, config);
    var node = this;
    node.on("input", function(msg) {
      node.status({ fill: "blue", shape: "dot", text: "sending..." });
      try {
        var transporter = nodemailer.createTransport(msg.mail.transport);
        var mailOptions = msg.mail.options;
        transporter.sendMail(mailOptions, function(error, info){
          if(error){
            node.status({ fill: "red", shape: "dot", text: "error" });
            node.error(error);
          }else{
            msg.payload = info;
            node.status({});
            node.send(msg);
          }
        });
      }
      catch (e) {
        node.status({ fill: "red", shape: "dot", text: "error" });
        node.error(e);
      }
    });
  }
  RED.nodes.registerType("simple-sendmail", SimpleSendmail);
}