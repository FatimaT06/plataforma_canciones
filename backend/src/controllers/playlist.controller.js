const db = require("../config/db");


// ✅ Crear playlist
exports.createPlaylist = (req, res) => {
  const { nombre } = req.body;

  // ⚠️ validar user
  if (!req.user) {
    return res.status(401).json({ message: "No autorizado" });
  }

  const userId = req.user.id;

  if (!nombre) {
    return res.status(400).json({ message: "Nombre requerido" });
  }

  db.query(
    "INSERT INTO playlists (nombre, usuario_id) VALUES (?, ?)",
    [nombre, userId],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json(err);
      }

      res.json({
        message: "Playlist creada",
        id: result.insertId
      });
    }
  );
};

exports.getUserPlaylists = (req, res) => {

  if (!req.user) {
    return res.status(401).json({ message: "No autorizado" });
  }

  const userId = req.user.id;

  db.query(
    "SELECT * FROM playlists WHERE usuario_id = ?",
    [userId],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json(err);
      }

      res.json(result);
    }
  );
};

exports.addSongToPlaylist = (req, res) => {
  const { playlist_id, song_id } = req.body;

  if (!playlist_id || !song_id) {
    return res.status(400).json({ message: "Datos incompletos" });
  }

  db.query(
    "SELECT * FROM playlist_canciones WHERE playlist_id = ? AND cancion_id = ?",
    [playlist_id, song_id],
    (err, result) => {
      if (err) return res.status(500).json(err);

      if (result.length > 0) {
        return res.json({ message: "La canción ya está en la playlist" });
      }

      db.query(
        "INSERT INTO playlist_canciones (playlist_id, cancion_id) VALUES (?, ?)",
        [playlist_id, song_id],
        (err2) => {
          if (err2) return res.status(500).json(err2);

          res.json({ message: "Canción agregada a la playlist 🎧" });
        }
      );
    }
  );
};

exports.getPlaylistSongs = (req, res) => {
  const playlistId = req.params.id;

  db.query(
    `SELECT s.* 
     FROM playlist_canciones pc
     JOIN canciones s ON pc.cancion_id = s.id
     WHERE pc.playlist_id = ?`,
    [playlistId],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json(err);
      }

      res.json(result);
    }
  );
};

exports.removeSongFromPlaylist = (req, res) => {
  const { playlist_id, song_id } = req.body;

  if (!playlist_id || !song_id) {
    return res.status(400).json({ message: "Datos incompletos" });
  }

  db.query(
    "DELETE FROM playlist_canciones WHERE playlist_id = ? AND cancion_id = ?",
    [playlist_id, song_id],
    (err) => {
      if (err) return res.status(500).json(err);

      res.json({ message: "Canción eliminada" });
    }
  );
};
