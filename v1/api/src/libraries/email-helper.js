const Path = require("path");
const Mailgun = require("./mail-gun");
const Handlebars = require("handlebars");
const fs = require("fs");

const sendOTP = (to, { recipient_name, OTP }) => {
  const filterPath = Path.join(__dirname, `../assets/email-templates/OTP.html`);
  const source = fs.readFileSync(filterPath, "utf-8");
  const template = Handlebars.compile(source);

  let emailData = {
    from: "Tour De Lantapan <tourdelantapan@tourdelantapan.com>",
    to,
    subject: "OTP: Tour de Lantapan",
    html: template({ recipient_name, OTP }),
  };

  Mailgun.send(emailData, (res) => {
    if (res) {
      console.log("success", res);
    }
  });
};

module.exports = {
  sendOTP,
};
