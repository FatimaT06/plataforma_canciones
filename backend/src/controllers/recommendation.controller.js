const db = require("../config/db");

exports.getRecommendations = (req, res) => {
    const user = req.params.user;

    db.query(`
        SELECT genero, COUNT(*) as total
        FROM historial h
        JOIN canciones s ON h.cancion_id = s.id
        WHERE usuario_id = ?
        GROUP BY genero
        ORDER BY total DESC
        LIMIT 1
    `, [user], (err, result) => {

        if (!result.length) return res.json([]);

        const genero = result[0].genero;

        db.query(
        "SELECT * FROM canciones WHERE genero = ? LIMIT 10",
        [genero],
        (err, songs) => res.json(songs)
        );
    });
};
