import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recommendation_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/song_provider.dart';
import '../widgets/song_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/color_constants.dart';
import 'player_screen.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }
  
  Future<void> _loadRecommendations() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final recommendationProvider = Provider.of<RecommendationProvider>(context, listen: false);
    
    if (authProvider.token != null && authProvider.user != null) {
      await recommendationProvider.loadRecommendations(
        authProvider.token!,
        authProvider.user!.id,
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final recommendationProvider = Provider.of<RecommendationProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return RefreshIndicator(
      onRefresh: _loadRecommendations,
      child: recommendationProvider.isLoading
          ? LoadingWidget()
          : recommendationProvider.recommendations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.recommend, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No hay recomendaciones aún',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Escucha más canciones para recibir recomendaciones',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loadRecommendations,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text('Actualizar'),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recomendaciones para ti',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Basado en tus gustos musicales',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.white),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'La IA ha seleccionado estas canciones especialmente para ti',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 8),
                        itemCount: recommendationProvider.recommendations.length,
                        itemBuilder: (context, index) {
                          final song = recommendationProvider.recommendations[index];
                          return SongCard(
                            song: song,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PlayerScreen(
                                    songs: recommendationProvider.recommendations,
                                    initialIndex: index,
                                    playlistId: null,
                                  ),
                                ),
                              );
                            },
                            trailingIcon: Icons.playlist_add,
                            onTrailingTap: () {
                              _showAddToPlaylistDialog(
                                context,
                                authProvider.token!,
                                song.id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
  
  void _showAddToPlaylistDialog(BuildContext context, String token, String songId) {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar a playlist',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              if (playlistProvider.playlists.isEmpty)
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No tienes playlists creadas'),
                )
              else
                ...playlistProvider.playlists.map((playlist) {
                  return ListTile(
                    leading: Icon(Icons.playlist_play, color: AppColors.primary),
                    title: Text(playlist.name),
                    subtitle: Text('${playlist.songs.length} canciones'),
                    onTap: () async {
                      Navigator.pop(context);
                      final success = await playlistProvider.addSongToPlaylist(
                        token,
                        playlist.id,
                        songId,
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Canción agregada a ${playlist.name}'
                                : 'Error al agregar canción',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    },
                  );
                }),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}