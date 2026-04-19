import 'song.dart';

class Playlist {
  final String id;
  final String name;
  List<Song> songs;

  Playlist({
    required this.id,
    required this.name,
    this.songs = const [],
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    List<Song> songList = [];
    if (json['songs'] != null) {
      songList = (json['songs'] as List)
          .map((song) => Song.fromJson(song))
          .toList();
    }
    
    return Playlist(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      songs: songList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'songs': songs.map((song) => song.toJson()).toList(),
    };
  }
}