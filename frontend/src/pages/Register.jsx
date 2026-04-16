import { useState } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";

export default function Register() {
  const [form, setForm] = useState({});
  const navigate = useNavigate();

  const handleSubmit = async () => {
    await API.post("/auth/register", form);
    alert("Usuario registrado");
    navigate("/login");
  };

  return (
    <div>
      <h2>Registro</h2>

      <input placeholder="Nombre" onChange={e => setForm({...form, nombre: e.target.value})}/>
      <input placeholder="Email" onChange={e => setForm({...form, email: e.target.value})}/>
      <input type="password" placeholder="Password" onChange={e => setForm({...form, password: e.target.value})}/>

      <button onClick={handleSubmit}>Registrarse</button>
    </div>
  );
}
