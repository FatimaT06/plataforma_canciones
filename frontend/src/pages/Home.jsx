import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import { logout } from "../services/auth";
import Player from "../components/Player";

export default function Home() {
  const [songs, setSongs] = useState([]);
  const [current, setCurrent] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    API.get("/songs").then(res => setSongs(res.data));
  }, []);

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div style={{ background: "#121212", color: "white", padding: "20px" }}>
      <h1>🎧 Plataforma Canciones</h1>

      <button onClick={handleLogout}>Cerrar sesión</button>

      {songs.map(song => (
        <div key={song.id}>
          <input type="checkbox" />
          {song.nombre} - {song.artista}
          <button onClick={() => setCurrent(song)}>▶</button>
        </div>
      ))}

      {current && <Player song={current} />}
    </div>
  );
}
