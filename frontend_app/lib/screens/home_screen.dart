import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/song_provider.dart';
import '../providers/auth_provider.dart';
import '../models/song.dart';
import 'player_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final songProvider = Provider.of<SongProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('A&F Music'),
        backgroundColor: const Color(0xFFDF3232),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
        ],
      ),
      body: songProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : songProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${songProvider.error}'),
                      ElevatedButton(
                        onPressed: () => songProvider.loadSongs(authProvider.token!),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : songProvider.songs.isEmpty
                  ? const Center(
                      child: Text('No hay canciones disponibles'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: songProvider.songs.length,
                      itemBuilder: (context, index) {
                        final song = songProvider.songs[index];
                        return _SongCard(song: song, index: index, songs: songProvider.songs);
                      },
                    ),
    );
  }
}

class _SongCard extends StatelessWidget {
  final Song song;
  final int index;
  final List<Song> songs;

  const _SongCard({required this.song, required this.index, required this.songs});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFDF3232),
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${song.artist} • ${song.genre}'),
        trailing: const Icon(Icons.play_arrow, color: Color(0xFFDF3232)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PlayerScreen(songs: songs, initialIndex: index),
            ),
          );
        },
      ),
    );
  }
}