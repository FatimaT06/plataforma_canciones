class Song {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final String url;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.url,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      title: json['title'] ?? 'Sin título',
      artist: json['artist'] ?? 'Artista desconocido',
      genre: json['genre'] ?? 'Otro',
      url: json['url'] ?? '',
    );
  }

  // Agregar el método toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genre': genre,
      'url': url,
    };
  }
}