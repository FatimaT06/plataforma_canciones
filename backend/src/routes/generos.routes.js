const router = require("express").Router();
const { getGeneros } = require("../controllers/generos.controller");

router.get("/", getGeneros);

module.exports = router;
