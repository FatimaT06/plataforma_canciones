import { useState } from "react";
import { useNavigate, Outlet } from "react-router-dom";
import { logout } from "../services/auth";
import Player from "./Player";
import "../styles/app.css";

export default function Layout() {
  const [songs, setSongs] = useState([]);
  const [currentIndex, setCurrentIndex] = useState(null);

  const navigate = useNavigate();
  const user = JSON.parse(localStorage.getItem("user"));

  const handleLogout = () => {
    logout();
    navigate("/login");
  };

  return (
    <div className="home">
      <div className="home-header">
        <h2>A&F Music</h2>

        <div className="user-section">
          <span>{user?.nombre}</span>

          <button onClick={() => navigate("/")}>Inicio</button>
          <button onClick={() => navigate("/playlists")}>Playlists</button>

          {user?.rol === "admin" && (
            <button onClick={() => navigate("/upload")}>
              + Subir
            </button>
          )}

          <button onClick={handleLogout}>
            Cerrar sesión
          </button>
        </div>
      </div>
      <Outlet context={{ songs, setSongs, currentIndex, setCurrentIndex }} />
      <Player
        songs={songs}
        currentIndex={currentIndex}
        setCurrentIndex={setCurrentIndex}
      />

    </div>
  );
}
