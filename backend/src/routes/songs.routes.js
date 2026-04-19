const router = require("express").Router();
const {
  getSongs,
  uploadSong,
  playSong,
  recommendAI
} = require("../controllers/songs.controller");

const auth = require("../middlewares/auth.middleware");
const admin = require("../middlewares/admin.middleware");
const upload = require("../middlewares/upload.middleware");

// 🎧 canciones
router.get("/", getSongs);

// 🎧 guardar historial
router.post("/play", auth, playSong);

// 🤖 IA
router.get("/recommend-ai", auth, recommendAI);

// 🎧 subir canción
router.post(
  "/upload",
  auth,
  admin,
  upload.fields([
    { name: "imagen", maxCount: 1 },
    { name: "audio", maxCount: 1 }
  ]),
  uploadSong
);

module.exports = router;
