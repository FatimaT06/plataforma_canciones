import { useEffect, useRef } from "react";
import "../styles/app.css";

export default function Player({ songs, currentIndex, setCurrentIndex }) {
  const audioRef = useRef(null);
  const song = songs[currentIndex];

  useEffect(() => {
    if (audioRef.current && song) {
      audioRef.current.load();
      audioRef.current.play().catch(() => {});
    }
  }, [currentIndex, song]);

  if (currentIndex === null || !song) return null;

  const next = () => {
    if (currentIndex < songs.length - 1) {
      setCurrentIndex(currentIndex + 1);
    }
  };

  const prev = () => {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1);
    }
  };

  return (
    <div className="player">

      <div className="player-left">
        <img src={song.imagen} />
        <div>
          <div className="player-title">{song.nombre}</div>
          <div className="player-artist">{song.artista}</div>
        </div>
      </div>

      <div className="player-center">
        <button onClick={prev}>⏮</button>

        <audio ref={audioRef} controls onEnded={next}>
          <source src={song.archivo_mp3} type="audio/mpeg" />
        </audio>

        <button onClick={next}>⏭</button>
      </div>

    </div>
  );
}
