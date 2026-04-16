const router = require("express").Router();
const { getSongs } = require("../controllers/songs.controller");

router.get("/", getSongs);

module.exports = router;
