const db = require("../config/db");

exports.getSongs = (req, res) => {
  db.query("SELECT * FROM canciones", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
});
};
