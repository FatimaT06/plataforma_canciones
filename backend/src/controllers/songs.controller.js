const db = require("../config/db");

exports.getSongs = (req, res) => {
  db.query("SELECT * FROM canciones", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
};

exports.uploadSong = (req, res) => {
  try {
    const {
      nombre,
      genero_id,
      duracion,
      artista,
      fecha_lanzamiento,
      album
    } = req.body;

    const imagen = req.files["imagen"][0].path;
    const audio = req.files["audio"][0].path;

    db.query(
      `INSERT INTO canciones 
      (nombre, genero_id, duracion, artista, fecha_lanzamiento, album, imagen, archivo_mp3)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [nombre, genero_id, duracion, artista, fecha_lanzamiento, album, imagen, audio],
      (err) => {
        if (err) return res.status(500).json(err);

        res.json({
          message: "Canción subida correctamente 🎧",
          imagen,
          audio
        });
      }
    );

  } catch (error) {
    res.status(500).json({ error: "Error al subir canción" });
  }
};
