const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
        return res.status(401).json("No autorizado");
    }

    const token = authHeader.split(" ")[1];

    if (!token) {
        return res.status(401).json("Token mal formado");
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded;
        next();
    } catch (err) {
        console.error(err);
        res.status(401).json("Token inválido");
    }
};
