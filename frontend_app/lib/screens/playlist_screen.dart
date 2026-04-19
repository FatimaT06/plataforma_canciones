import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/auth_provider.dart';
// Eliminar esta línea porque no se usa directamente
// import '../models/playlist.dart';
import '../widgets/playlist_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/color_constants.dart';
import 'create_playlist_screen.dart';
import 'playlist_detail_screen.dart';

class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});  // Usar super.key en lugar de key: key
  
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
            ? const LoadingWidget()
            : playlistProvider.playlists.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.playlist_play, size: 80, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No tienes playlists creadas',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
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
                          child: const Text('Crear Playlist'),
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
                              builder: (context) => PlaylistDetailScreen(  // Quitar const aquí
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
        child: const Icon(Icons.add),
      ),
    );
  }
}