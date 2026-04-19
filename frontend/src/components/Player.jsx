import { useEffect, useRef, useState } from "react";
import API from "../services/api";
import "../styles/app.css";

export default function Player({ songs, currentIndex, setCurrentIndex }) {
  const audioRef = useRef(null);
  const song = songs[currentIndex];

  const [isPlaying, setIsPlaying] = useState(false);
  const [currentTime, setCurrentTime] = useState(0);
  const [duration, setDuration] = useState(0);

  const token = localStorage.getItem("token");

  useEffect(() => {
    if (audioRef.current && song) {
      audioRef.current.load();
      audioRef.current.play().catch(() => {});
      setIsPlaying(true);
      setCurrentTime(0);

      // 🎧 guardar historial
      API.post(
        "/songs/play",
        { song_id: song.id },
        {
          headers: { Authorization: `Bearer ${token}` }
        }
      ).catch(err => console.error(err));
    }
  }, [currentIndex]);

  if (currentIndex === null || !song) return null;

  const next = () => {
    if (currentIndex < songs.length - 1) {
      setCurrentIndex(currentIndex + 1);
    }
  };

  const prev = () => {
    if (currentIndex > 0) setCurrentIndex(currentIndex - 1);
  };

  const togglePlay = () => {
    if (!audioRef.current) return;

    if (isPlaying) {
      audioRef.current.pause();
      setIsPlaying(false);
    } else {
      audioRef.current.play();
      setIsPlaying(true);
    }
  };

  const handleTimeUpdate = () => {
    setCurrentTime(audioRef.current.currentTime);
  };

  const handleLoadedMetadata = () => {
    setDuration(audioRef.current.duration);
  };

  const handleSeek = (e) => {
    const val = parseFloat(e.target.value);
    audioRef.current.currentTime = val;
    setCurrentTime(val);
  };

  const fmt = (s) => {
    const m = Math.floor(s / 60);
    const sec = Math.floor(s % 60).toString().padStart(2, "0");
    return `${m}:${sec}`;
  };

  const handleEnded = async () => {
    try {
      const res = await API.get("/songs/recommend-ai", {
        headers: { Authorization: `Bearer ${token}` }
      });

      if (res.data) {
        const index = songs.findIndex(s => s.id === res.data.id);

        if (index !== -1) {
          setCurrentIndex(index);
          return;
        }
      }

      next();

    } catch (err) {
      console.error("IA error:", err);
      next();
    }
  };

  return (
    <div className="player">
      <audio
        ref={audioRef}
        onTimeUpdate={handleTimeUpdate}
        onLoadedMetadata={handleLoadedMetadata}
        onEnded={handleEnded}
      >
        <source src={song.archivo_mp3} type="audio/mpeg" />
      </audio>

      <div className="player-left">
        <img src={song.imagen} alt={song.nombre} />
        <div>
          <div className="player-title">{song.nombre}</div>
          <div className="player-artist">{song.artista}</div>
        </div>
      </div>

      <div className="player-center">
        <button className="player-ctrl" onClick={prev}>⏮</button>

        <button className="player-play" onClick={togglePlay}>
          {isPlaying ? "⏸" : "▶"}
        </button>

        <button className="player-ctrl" onClick={next}>⏭</button>

        <span className="player-time">{fmt(currentTime)}</span>

        <input
          className="player-seek"
          type="range"
          min={0}
          max={duration || 0}
          step={0.1}
          value={currentTime}
          onChange={handleSeek}
        />

        <span className="player-time">{fmt(duration)}</span>
      </div>
    </div>
  );
}
