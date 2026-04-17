const SibApiV3Sdk = require("sib-api-v3-sdk");

const sendEmail = async (toEmail) => {
  const client = SibApiV3Sdk.ApiClient.instance;

  const apiKey = client.authentications["api-key"];
  apiKey.apiKey = process.env.BREVO_API_KEY;

  const tranEmailApi = new SibApiV3Sdk.TransactionalEmailsApi();

  await tranEmailApi.sendTransacEmail({
    sender: { email: "fatima.torres061102@gmail.com", name: "A&F Music" },
    to: [{ email: toEmail }],
    subject: "Bienvenido 🎧",
    htmlContent: "<h1>Tu cuenta fue creada correctamente</h1>"
  });
};

module.exports = sendEmail;
