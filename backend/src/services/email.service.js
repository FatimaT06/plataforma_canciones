const nodemailer = require("nodemailer");

const sendEmail = async (email) => {
    const transporter = nodemailer.createTransport({
        service: "gmail",
        auth: {
        user: process.env.EMAIL,
        pass: process.env.EMAIL_PASS
        }
    });

    await transporter.sendMail({
        to: email,
        subject: "Bienvenido",
        html: "<h1>Cuenta creada correctamente</h1>"
    });
};

module.exports = sendEmail;
