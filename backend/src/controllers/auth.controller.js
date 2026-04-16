const db = require("../config/db");
const bcrypt = require("bcrypt");
const { generateToken } = require("../utils/generateToken");
const sendEmail = require("../services/email.service");

exports.login = (req, res) => {
  const { email, password } = req.body;

  db.query(
    "SELECT * FROM usuarios WHERE email = ?",
    [email],
    async (err, result) => {
      if (err) return res.status(500).json(err);

      if (result.length === 0) {
        return res.status(400).json({ message: "Usuario no existe" });
      }

      const user = result[0];

      const validPassword = await bcrypt.compare(password, user.password);

      if (!validPassword) {
        return res.status(400).json({ message: "Contraseña incorrecta" });
      }

      const token = generateToken(user);

      res.json({
        token,
        user: {
          id: user.id,
          nombre: user.nombre,
          email: user.email
        }
      });
    }
  );
};

exports.register = async (req, res) => {
    const { nombre, email, password } = req.body;

    const hash = await bcrypt.hash(password, 10);

    db.query(
        "INSERT INTO usuarios (nombre,email,password) VALUES (?,?,?)",
        [nombre, email, hash],
        async (err) => {
        if (err) return res.status(500).json(err);

        await sendEmail(email);

        res.json({ message: "Usuario registrado" });
        }
    );
};
