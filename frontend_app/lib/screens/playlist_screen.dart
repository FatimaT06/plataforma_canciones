import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/playlist_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/color_constants.dart';
import 'create_playlist_screen.dart';
import 'playlist_detail_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (authProvider.token != null) {
            await playlistProvider.loadPlaylists(authProvider.token!);
          }
        },
        child: playlistProvider.isLoading
            ? LoadingWidget()
            : playlistProvider.playlists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.playlist_play, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No tienes playlists creadas',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreatePlaylistScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: Text('Crear Playlist'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: playlistProvider.playlists.length,
                    itemBuilder: (context, index) {
                      final playlist = playlistProvider.playlists[index];
                      return PlaylistCard(
                        playlist: playlist,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaylistDetailScreen(
                                playlistId: playlist.id,
                                playlistName: playlist.name,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreatePlaylistScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add),
      ),
    );
  }
}

class PlaylistDetailScreen extends StatefulWidget {
  final String playlistId;
  final String playlistName;
  
  const PlaylistDetailScreen({
    required this.playlistId,
    required this.playlistName,
  });
  
  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  Playlist? _playlist;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPlaylistDetails();
  }
  
  Future<void> _loadPlaylistDetails() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    
    if (authProvider.token != null) {
      final playlist = await playlistProvider.getPlaylistDetails(
        authProvider.token!,
        widget.playlistId,
      );
      setState(() {
        _playlist = playlist;
        _isLoading = false;
      });
    }
  }
  
  Future<void> _removeSongFromPlaylist(String songId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    
    final success = await playlistProvider.removeSongFromPlaylist(
      authProvider.token!,
      widget.playlistId,
      songId,
    );
    
    if (success) {
      await _loadPlaylistDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Canción eliminada de la playlist'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar canción'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? LoadingWidget()
          : _playlist == null || _playlist!.songs.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.music_note, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Esta playlist está vacía',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      Text(
                        'Agrega canciones desde la pantalla principal',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _playlist!.songs.length,
                  itemBuilder: (context, index) {
                    final song = _playlist!.songs[index];
                    return SongCard(
                      song: song,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayerScreen(
                              songs: _playlist!.songs,
                              initialIndex: index,
                              playlistId: widget.playlistId,
                            ),
                          ),
                        );
                      },
                      trailingIcon: Icons.delete,
                      onTrailingTap: () {
                        _showDeleteDialog(context, song.id, song.title);
                      },
                    );
                  },
                ),
    );
  }
  
  void _showDeleteDialog(BuildContext context, String songId, String songTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar canción'),
        content: Text('¿Deseas eliminar "$songTitle" de esta playlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeSongFromPlaylist(songId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}