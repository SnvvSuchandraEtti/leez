const nodemailer = require("nodemailer");

var sendMail = async (receiver, subject, message) => {
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
            user: "adityauniversityclubs@gmail.com",
            pass: "mqvm vqon kxis tjcj",
        },
    });

    const mailOptions = {
        from: "adityauniversityclubs@gmail.com",
        to: receiver,
        subject: subject,
        text: message,
    };

    await transporter.sendMail(mailOptions, (err, info) => {
        if (err) {
            console.log(err);
            return false;
        }
        console.log(info);
        return true;
    });
};

module.exports = {
    sendMail,
};
