import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import { logout } from "../services/auth";
import Player from "../components/Player";

export default function Home() {
  const [songs, setSongs] = useState([]);
  const [current, setCurrent] = useState(null);
  const [selectedSongs, setSelectedSongs] = useState([]);

  const navigate = useNavigate();

  const user = JSON.parse(localStorage.getItem("user"));

  useEffect(() => {
    API.get("/songs").then(res => setSongs(res.data));
  }, []);

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  const handleSelect = (id) => {
    if (selectedSongs.includes(id)) {
      setSelectedSongs(selectedSongs.filter(s => s !== id));
    } else {
      setSelectedSongs([...selectedSongs, id]);
    }
  };

  return (
    <div style={{ background: "#121212", color: "white", padding: "20px" }}>
      
      <h1>🎧 Plataforma Canciones</h1>

      <p>Bienvenido: {user?.nombre} ({user?.rol})</p>

      <button onClick={handleLogout}>Cerrar sesión</button>

      {user?.rol === "admin" && (
        <button onClick={() => navigate("/upload")}>
          Subir canción 🎧
        </button>
      )}

      <hr />

      {songs.map(song => (
        <div key={song.id} style={styles.song}>
          
          <input
            type="checkbox"
            onChange={() => handleSelect(song.id)}
          />

          <span>
            {song.nombre} - {song.artista}
          </span>

          <button onClick={() => setCurrent(song)}>▶</button>
        </div>
      ))}

      {current && <Player song={current} />}

      <div>
        <h3>Seleccionadas:</h3>
        {selectedSongs.join(", ")}
      </div>

    </div>
  );
}

const styles = {
  song: {
    display: "flex",
    gap: "10px",
    alignItems: "center",
    marginBottom: "10px"
  }
};
