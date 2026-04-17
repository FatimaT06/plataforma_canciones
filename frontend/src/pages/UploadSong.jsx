import { useEffect, useState, useRef } from "react";
import { useNavigate } from "react-router-dom";
import API from "../services/api";

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

  // 🔥 refs para limpiar inputs file
  const imagenRef = useRef();
  const audioRef = useRef();

  const token = localStorage.getItem("token");

  useEffect(() => {
    API.get("/generos")
      .then(res => setGeneros(res.data))
      .catch(err => console.error(err));
  }, []);

  const handleChange = (e) => {
    setForm({
      ...form,
      [e.target.name]: e.target.value
    });
  };

  const resetForm = () => {
    setForm({
      nombre: "",
      genero_id: "",
      duracion: "",
      artista: "",
      fecha_lanzamiento: "",
      album: ""
    });

    setImagen(null);
    setAudio(null);

    // 🔥 limpiar inputs file visualmente
    if (imagenRef.current) imagenRef.current.value = "";
    if (audioRef.current) audioRef.current.value = "";
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const data = new FormData();

    Object.keys(form).forEach(key => {
      data.append(key, form[key]);
    });

    data.append("imagen", imagen);
    data.append("audio", audio);

    try {
      await API.post("/songs/upload", data, {
        headers: {
          Authorization: `Bearer ${token}`
        }
      });

      alert("Canción subida 🎧🔥");

      // ✅ limpiar formulario
      resetForm();

      // 👉 opcional: regresar al home después de 1s
      setTimeout(() => {
        navigate("/");
      }, 1000);

    } catch (err) {
      console.error(err);
      alert("Error al subir canción");
    }
  };

  return (
    <div style={styles.container}>
      <h2>Subir Canción 🎧</h2>

      {/* 🔥 botón regresar */}
      <button onClick={() => navigate("/")}>
        ⬅ Volver al Home
      </button>

      <form onSubmit={handleSubmit} style={styles.form}>
        
        <input 
          name="nombre" 
          placeholder="Nombre" 
          value={form.nombre}
          onChange={handleChange} 
        />

        <select 
          name="genero_id" 
          value={form.genero_id}
          onChange={handleChange}
        >
          <option value="">Selecciona un género</option>
          {generos.map(g => (
            <option key={g.id} value={g.id}>
              {g.nombre}
            </option>
          ))}
        </select>

        <input 
          name="duracion" 
          placeholder="Duración" 
          value={form.duracion}
          onChange={handleChange} 
        />

        <input 
          name="artista" 
          placeholder="Artista" 
          value={form.artista}
          onChange={handleChange} 
        />

        <input 
          type="date" 
          name="fecha_lanzamiento" 
          value={form.fecha_lanzamiento}
          onChange={handleChange} 
        />

        <input 
          name="album" 
          placeholder="Álbum" 
          value={form.album}
          onChange={handleChange} 
        />

        <label>Imagen:</label>
        <input 
          type="file" 
          ref={imagenRef}
          onChange={(e) => setImagen(e.target.files[0])} 
        />

        <label>Audio MP3:</label>
        <input 
          type="file" 
          ref={audioRef}
          onChange={(e) => setAudio(e.target.files[0])} 
        />

        <button type="submit">Subir</button>

      </form>
    </div>
  );
}

const styles = {
  container: {
    padding: "20px",
    color: "white",
    background: "#121212",
    minHeight: "100vh"
  },
  form: {
    display: "flex",
    flexDirection: "column",
    gap: "10px",
    maxWidth: "400px"
  }
};
