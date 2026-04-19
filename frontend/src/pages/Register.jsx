import { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import "../styles/app.css";

export default function Register() {
  const [form, setForm] = useState({});
  const navigate = useNavigate();

  const handleSubmit = async () => {
    try {
      await API.post("/auth/register", form);
      alert("Usuario registrado");
      navigate("/login");
    } catch (err) {
      alert("Error al registrarse");
    }
  };

  return (
    <div className="auth-container">

      <div className="auth-box">
        <h2>Registrar Cuenta</h2>

        <input
          placeholder="Nombre"
          onChange={e => setForm({ ...form, nombre: e.target.value })}
        />

        <input
          placeholder="Email"
          onChange={e => setForm({ ...form, email: e.target.value })}
        />

        <input
          type="password"
          placeholder="Password"
          onChange={e => setForm({ ...form, password: e.target.value })}
        />

        <button onClick={handleSubmit}>
          Registrarse
        </button>

        <p onClick={() => navigate("/login")}>
          ¿Ya tienes cuenta? Inicia sesión
        </p>

      </div>

    </div>
  );
}
