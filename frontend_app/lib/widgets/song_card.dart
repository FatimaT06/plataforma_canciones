import 'package:flutter/material.dart';
import '../models/song.dart';
import '../utils/color_constants.dart';

class SongCard extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;

  const SongCard({
    required this.song,
    required this.onTap,
    this.trailingIcon,
    this.onTrailingTap,
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
            Icons.music_note,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${song.artist} • ${song.genre}'),
        trailing: trailingIcon != null
            ? IconButton(
                icon: Icon(trailingIcon, color: AppColors.primary),
                onPressed: onTrailingTap,
              )
            : Icon(Icons.play_arrow, color: AppColors.primary),
        onTap: onTap,
      ),
    );
  }
}