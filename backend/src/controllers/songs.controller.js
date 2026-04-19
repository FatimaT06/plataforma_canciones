const db = require("../config/db");

// 🎧 Obtener canciones
exports.getSongs = (req, res) => {
  db.query("SELECT * FROM canciones", (err, result) => {
    if (err) return res.status(500).json(err);
    res.json(result);
  });
};

// 🎧 Subir canción
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

// 🎧 Guardar reproducción
exports.playSong = (req, res) => {
  const userId = req.user.id;
  const { song_id } = req.body;

  if (!song_id) {
    return res.status(400).json({ message: "song_id requerido" });
  }

  db.query(
    "INSERT INTO historial (usuario_id, cancion_id) VALUES (?, ?)",
    [userId, song_id],
    (err) => {
      if (err) {
        console.error(err);
        return res.status(500).json(err);
      }

      res.json({ message: "Reproducción guardada 🎧" });
    }
  );
};

// 🤖 IA: recomendar siguiente canción
exports.recommendAI = (req, res) => {
  const userId = req.user.id;

  // 1. obtener género más escuchado
  db.query(
    `SELECT c.genero_id, COUNT(*) as total
     FROM historial h
     JOIN canciones c ON h.cancion_id = c.id
     WHERE h.usuario_id = ?
     GROUP BY c.genero_id
     ORDER BY total DESC
     LIMIT 1`,
    [userId],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json(err);
      }

      // 🟡 si no hay historial → random
      if (result.length === 0) {
        return db.query(
          "SELECT * FROM canciones ORDER BY RAND() LIMIT 1",
          (err2, songs) => {
            if (err2) return res.status(500).json(err2);
            res.json(songs[0]);
          }
        );
      }

      const generoFav = result[0].genero_id;

      // 2. recomendar canción de ese género
      db.query(
        `SELECT * FROM canciones 
         WHERE genero_id = ?
         ORDER BY RAND()
         LIMIT 1`,
        [generoFav],
        (err2, songs) => {
          if (err2) {
            console.error(err2);
            return res.status(500).json(err2);
          }

          res.json(songs[0]);
        }
      );
    }
  );
};
