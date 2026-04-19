class Song {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final String url;
  bool isPlaying;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    required this.url,
    this.isPlaying = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      artist: json['artist'] ?? '',
      genre: json['genre'] ?? '',
      url: json['url'] ?? '',
    );
  }

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