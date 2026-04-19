import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../utils/color_constants.dart';

class PlaylistCard extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onTap;

  const PlaylistCard({
    required this.playlist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.playlist_play,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        title: Text(
          playlist.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${playlist.songs.length} canciones'),
        trailing: Icon(Icons.chevron_right, color: AppColors.primary),
        onTap: onTap,
      ),
    );
  }
}