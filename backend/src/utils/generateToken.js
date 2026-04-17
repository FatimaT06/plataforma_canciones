const jwt = require("jsonwebtoken");

exports.generateToken = (user) => {
  return jwt.sign(
    { id: user.id, email: user.email , rol:user.rol},
    process.env.JWT_SECRET,
    { expiresIn: "7d" }
  );
};