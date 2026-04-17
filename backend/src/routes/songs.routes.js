const router = require("express").Router();
const { getSongs, uploadSong } = require("../controllers/songs.controller");
const auth = require("../middlewares/auth.middleware");
const admin = require("../middlewares/admin.middleware");
const upload = require("../middlewares/upload.middleware");

console.log("UPLOAD:", typeof upload);

router.get("/", getSongs);

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
