export default function Player({ song }) {
  return (
    <div>
      <h3>Reproduciendo: {song.nombre}</h3>
      <audio controls autoPlay>
        <source src={song.archivo_mp3} type="audio/mpeg" />
      </audio>
    </div>
  );
}
