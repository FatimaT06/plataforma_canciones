import { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import { saveToken } from "../services/auth";
import "../styles/app.css";

export default function Login() {
  const [form, setForm] = useState({});
  const navigate = useNavigate();

  const handleLogin = async () => {
    try {
      const res = await API.post("/auth/login", form);

      saveToken(res.data.token);
      localStorage.setItem("user", JSON.stringify(res.data.user));

      navigate("/");
    } catch (err) {
      alert("Error al iniciar sesión");
    }
  };

  return (
    <div className="auth-container">

      <div className="auth-box">
        <h2>Iniciar Sesión</h2>

        <input
          placeholder="Email"
          onChange={e => setForm({ ...form, email: e.target.value })}
        />

        <input
          type="password"
          placeholder="Password"
          onChange={e => setForm({ ...form, password: e.target.value })}
        />

        <button onClick={handleLogin}>
          Entrar
        </button>

        <p onClick={() => navigate("/register")}>
          ¿No tienes cuenta? Regístrate
        </p>
      </div>

    </div>
  );
}