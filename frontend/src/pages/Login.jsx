import { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import { saveToken } from "../services/auth";

export default function Login() {
  const [form, setForm] = useState({});
  const navigate = useNavigate();

  const handleLogin = async () => {
    const res = await API.post("/auth/login", form);

    saveToken(res.data.token);

    localStorage.setItem("user", JSON.stringify(res.data.user));

    navigate("/");
  };

  return (
    <div>
      <h2>Login</h2>

      <input
        placeholder="Email"
        onChange={e => setForm({...form, email: e.target.value})}
      />

      <input
        type="password"
        placeholder="Password"
        onChange={e => setForm({...form, password: e.target.value})}
      />

      <button onClick={handleLogin}>Entrar</button>
      <button onClick={() => navigate("/register")}>Registrarse</button>
    </div>
  );
}
