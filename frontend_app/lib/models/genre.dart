class Genre {
  final String name;

  Genre({required this.name});

  factory Genre.fromJson(String name) {
    return Genre(name: name);
  }
}