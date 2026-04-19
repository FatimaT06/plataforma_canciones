import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import { logout } from "../services/auth";
import Player from "../components/Player";
import "../styles/app.css";

export default function Home() {
  const [songs, setSongs] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(null);
  const [playlists, setPlaylists] = useState([]);
  const [showModal, setShowModal] = useState(false);
  const [selectedSong, setSelectedSong] = useState(null);
  const [newPlaylist, setNewPlaylist] = useState("");

  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem("user"));
  const token = localStorage.getItem("token");

  useEffect(() => {
    loadSongs();
    loadPlaylists();
  }, []);

  const loadSongs = async () => {
    const res = await API.get("/songs");
    setSongs(res.data);
  };

  const loadPlaylists = async () => {
    const res = await API.get("/playlists", {
      headers: { Authorization: `Bearer ${token}` }
    });
    setPlaylists(res.data);
  };

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  const openModal = (song) => {
    setSelectedSong(song);
    setShowModal(true);
  };

  const addToPlaylist = async (playlist_id) => {
    await API.post(
      "/playlists/add-song",
      { playlist_id, song_id: selectedSong.id },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    alert("Agregado");
    setShowModal(false);
  };

  const createPlaylist = async () => {
    if (!newPlaylist) return alert("Escribe un nombre");
    const res = await API.post(
      "/playlists",
      { nombre: newPlaylist },
      { headers: { Authorization: `Bearer ${token}` } }
    );
    await addToPlaylist(res.data.id);
    setNewPlaylist("");
    loadPlaylists();
  };

  return (
    <div className="home">
      <div className="home-header">
        <h2>A&F Music</h2>
        <div className="user-section">
          <span>{user?.nombre}</span>
          <button onClick={() => navigate("/playlists")}>Playlists</button>
          {user?.rol === "admin" && (
            <button onClick={() => navigate("/upload")}>+ Subir</button>
          )}
          <button onClick={handleLogout}>Cerrar sesión</button>
        </div>
      </div>

      <div className="songs-grid">
        {songs.map((song, index) => (
          <div key={song.id} className="song-card">
            <img src={song.imagen} alt={song.nombre} />
            <div className="song-info">
              <div className="song-title">{song.nombre}</div>
              <div className="song-artist">{song.artista}</div>
            </div>
            <div className="song-actions">
              <button
                className="play-button"
                onClick={() => setCurrentIndex(index)}
              >
                ▶
              </button>
              <button className="btn" onClick={() => openModal(song)}>
                + Playlist
              </button>
            </div>
          </div>
        ))}
      </div>

      {showModal && (
        <div className="modal">
          <div className="modal-content">
            <h3>Agregar a playlist</h3>
            {playlists.map(p => (
              <button key={p.id} className="btn" onClick={() => addToPlaylist(p.id)}>
                {p.nombre}
              </button>
            ))}
            <hr />
            <input
              placeholder="Nueva playlist"
              value={newPlaylist}
              onChange={(e) => setNewPlaylist(e.target.value)}
            />
            <button className="btn" onClick={createPlaylist}>
              Crear y agregar
            </button>
            <button className="btn cancel" onClick={() => setShowModal(false)}>
              Cancelar
            </button>
          </div>
        </div>
      )}

      <Player
        songs={songs}
        currentIndex={currentIndex}
        setCurrentIndex={setCurrentIndex}
      />
    </div>
  );
}