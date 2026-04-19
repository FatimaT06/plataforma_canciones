import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../utils/color_constants.dart';

class PlayerScreen extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;
  final String? playlistId;

  const PlayerScreen({
    required this.songs,
    required this.initialIndex,
    this.playlistId,
  });

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer audioPlayer;
  late int currentIndex;
  Duration currentDuration = Duration.zero;
  Duration totalDuration = Duration.zero;
  bool isPlaying = false;
  bool isShuffled = false;
  bool isRepeated = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    currentIndex = widget.initialIndex;
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _playSong(widget.songs[currentIndex].url);
    
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });
    
    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        currentDuration = position;
      });
    });
    
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    
    audioPlayer.onPlayerComplete.listen((event) {
      if (isRepeated) {
        _playSong(widget.songs[currentIndex].url);
      } else {
        _nextSong();
      }
    });
  }

  Future<void> _playSong(String url) async {
    await audioPlayer.stop();
    await audioPlayer.play(UrlSource(url));
  }

  Future<void> _togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
  }

  Future<void> _nextSong() async {
    if (currentIndex < widget.songs.length - 1) {
      setState(() {
        currentIndex++;
      });
      await _playSong(widget.songs[currentIndex].url);
    } else if (isRepeated) {
      setState(() {
        currentIndex = 0;
      });
      await _playSong(widget.songs[currentIndex].url);
    }
  }

  Future<void> _previousSong() async {
    if (currentDuration.inSeconds > 3) {
      await audioPlayer.seek(Duration.zero);
    } else if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      await _playSong(widget.songs[currentIndex].url);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : ''}$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = widget.songs[currentIndex];
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Reproduciendo'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.queue_music),
            onPressed: () {
              _showQueueDialog();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Artwork animado
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: isPlaying ? 1 : 0),
              duration: Duration(milliseconds: 500),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: 1 + (value * 0.05),
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.album,
                      size: 150,
                      color: AppColors.primary.withOpacity(0.5 + (value * 0.3)),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            
            // Información de la canción
            Text(
              currentSong.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              currentSong.artist,
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                currentSong.genre,
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 30),
            
            // Barra de progreso
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Slider(
                    value: currentDuration.inSeconds.toDouble(),
                    max: totalDuration.inSeconds.toDouble(),
                    onChanged: (value) {
                      final newDuration = Duration(seconds: value.toInt());
                      audioPlayer.seek(newDuration);
                    },
                    activeColor: Colors.white,
                    inactiveColor: Colors.white30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDuration(currentDuration),
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          _formatDuration(totalDuration),
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 20),
            
            // Controles del reproductor
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 30,
                  icon: Icon(
                    isShuffled ? Icons.shuffle : Icons.shuffle_outlined,
                    color: isShuffled ? Colors.white : Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      isShuffled = !isShuffled;
                    });
                  },
                ),
                SizedBox(width: 20),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.skip_previous),
                  color: Colors.white,
                  onPressed: _previousSong,
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    iconSize: 40,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: AppColors.primary,
                    ),
                    onPressed: _togglePlayPause,
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  iconSize: 50,
                  icon: Icon(Icons.skip_next),
                  color: Colors.white,
                  onPressed: _nextSong,
                ),
                SizedBox(width: 20),
                IconButton(
                  iconSize: 30,
                  icon: Icon(
                    isRepeated ? Icons.repeat : Icons.repeat_on,
                    color: isRepeated ? Colors.white : Colors.white70,
                  ),
                  onPressed: () {
                    setState(() {
                      isRepeated = !isRepeated;
                    });
                  },
                ),
              ],
            ),
            
            SizedBox(height: 20),
            
            // Información adicional
            Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoChip(
                    Icons.music_note,
                    '${currentIndex + 1}/${widget.songs.length}',
                  ),
                  _buildInfoChip(
                    Icons.playlist_play,
                    widget.playlistId != null ? 'En playlist' : 'Lista general',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white70),
        SizedBox(width: 4),
        Text(label, style: TextStyle(color: Colors.white70)),
      ],
    );
  }
  
  void _showQueueDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 400,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Text(
                  'Lista de reproducción',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.songs.length,
                  itemBuilder: (context, index) {
                    final song = widget.songs[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: currentIndex == index
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        child: Icon(
                          Icons.music_note,
                          size: 20,
                          color: currentIndex == index ? Colors.white : Colors.grey,
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: TextStyle(
                          fontWeight: currentIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: currentIndex == index
                              ? AppColors.primary
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(song.artist),
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });
                        _playSong(song.url);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}