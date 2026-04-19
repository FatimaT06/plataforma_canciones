import { useEffect, useState, useRef } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";
import "../styles/app.css";

export default function UploadSong() {
  const navigate = useNavigate();

  const [form, setForm] = useState({
    nombre: "",
    genero_id: "",
    duracion: "",
    artista: "",
    fecha_lanzamiento: "",
    album: ""
  });

  const [generos, setGeneros] = useState([]);
  const [imagen, setImagen] = useState(null);
  const [audio, setAudio] = useState(null);

  const imagenRef = useRef();
  const audioRef = useRef();

  const token = localStorage.getItem("token");

  useEffect(() => {
    API.get("/generos").then(res => setGeneros(res.data));
  }, []);

  const handleChange = e => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleSubmit = async e => {
    e.preventDefault();

    const data = new FormData();
    Object.keys(form).forEach(key => data.append(key, form[key]));

    if (imagen) data.append("imagen", imagen);
    if (audio) data.append("audio", audio);

    try {
      await API.post("/songs/upload", data, {
        headers: { Authorization: `Bearer ${token}` }
      });

      alert("Canción subida");
      navigate("/");
    } catch {
      alert("Error al subir canción");
    }
  };

  return (
    <div className="container-center">
      <div className="card-glass" style={{ width: "400px" }}>
        <h2 className="title">Subir canción</h2>

        <form onSubmit={handleSubmit}>

          <div className="input-group">
            <input className="input" name="nombre" placeholder=" " value={form.nombre} onChange={handleChange}/>
            <label className="label">Nombre</label>
          </div>

          <div className="input-group">
            <input className="input" name="artista" placeholder=" " value={form.artista} onChange={handleChange}/>
            <label className="label">Artista</label>
          </div>

          <div className="input-group">
            <input className="input" name="album" placeholder=" " value={form.album} onChange={handleChange}/>
            <label className="label">Álbum</label>
          </div>

          <div className="input-group">
            <input className="input" name="duracion" placeholder=" " value={form.duracion} onChange={handleChange}/>
            <label className="label">Duración</label>
          </div>

          <div className="input-group">
            <input type="date" className="input" name="fecha_lanzamiento" value={form.fecha_lanzamiento} onChange={handleChange}/>
          </div>

          <select className="select" name="genero_id" value={form.genero_id} onChange={handleChange}>
            <option value="">Selecciona género</option>
            {generos.map(g => (
              <option key={g.id} value={g.id}>{g.nombre}</option>
            ))}
          </select>

          <div style={{ textAlign: "left", marginTop: "10px" }}>
            <label>Imagen:</label>
            <input type="file" ref={imagenRef} onChange={e => setImagen(e.target.files[0])}/>
          </div>

          <div style={{ textAlign: "left", marginTop: "10px" }}>
            <label>Audio:</label>
            <input type="file" ref={audioRef} onChange={e => setAudio(e.target.files[0])}/>
          </div>

          <button className="btn-primary" style={{ marginTop: "15px" }}>
            Subir canción
          </button>

          <button
            type="button"
            className="btn-secondary"
            onClick={() => navigate("/")}
          >
            Cancelar
          </button>

        </form>
      </div>
    </div>
  );
}
