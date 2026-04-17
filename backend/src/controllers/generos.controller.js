const db = require("../config/db");

exports.getGeneros = (req, res) => {
  db.query("SELECT * FROM generos", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
});
};