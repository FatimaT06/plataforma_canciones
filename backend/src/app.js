require("dotenv").config();
const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", require("./routes/auth.routes"));
app.use("/api/songs", require("./routes/songs.routes"));
app.use("/api/playlists", require("./routes/playlist.routes"));
app.use("/api/recommendations", require("./routes/recommendation.routes"));
app.use("/api/generos", require("./routes/generos.routes"));

module.exports = app;
