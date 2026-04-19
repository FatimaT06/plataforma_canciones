const router = require("express").Router();
const auth = require("../middlewares/auth.middleware");

const {
  createPlaylist,
  getUserPlaylists,
  addSongToPlaylist,
  getPlaylistSongs,
  removeSongFromPlaylist
} = require("../controllers/playlist.controller");

router.post("/", auth, createPlaylist);
router.get("/", auth, getUserPlaylists);
router.post("/add-song", auth, addSongToPlaylist);
router.get("/:id", auth, getPlaylistSongs);
router.delete("/remove-song", auth, removeSongFromPlaylist);

module.exports = router;
