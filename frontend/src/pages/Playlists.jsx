import { useEffect, useState } from "react";
import API from "../services/api";
import "../styles/app.css";
import Player from "../components/Player";

export default function Playlists() {
  const [playlists, setPlaylists] = useState([]);
  const [songs, setSongs] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(null);
  const [activeId, setActiveId] = useState(null);

  const token = localStorage.getItem("token");

  useEffect(() => {
    loadPlaylists();
  }, []);

  const loadPlaylists = async () => {
    const res = await API.get("/playlists", {
      headers: { Authorization: `Bearer ${token}` }
    });
    setPlaylists(res.data);
  };

  const loadSongs = async (id) => {
    const res = await API.get(`/playlists/${id}`, {
      headers: { Authorization: `Bearer ${token}` }
    });
    setSongs(res.data);
    setCurrentIndex(null);
    setActiveId(id);
  };

  return (
    <div className="container">
      <div className="main">

        <div className="playlist-buttons">
          {playlists.map(p => (
            <button
              key={p.id}
              className={`btn playlist-tab ${activeId === p.id ? "active" : ""}`}
              onClick={() => loadSongs(p.id)}
            >
              {p.nombre}
            </button>
          ))}
        </div>

        <h2 className="section-title">Canciones</h2>

        {songs.length === 0 ? (
          <p className="empty-msg">Selecciona una playlist para ver sus canciones</p>
        ) : (
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
                </div>
              </div>
            ))}
          </div>
        )}

      </div>

      <Player
        songs={songs}
        currentIndex={currentIndex}
        setCurrentIndex={setCurrentIndex}
      />
    </div>
  );
}