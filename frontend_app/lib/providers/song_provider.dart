import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/song_service.dart';

class SongProvider with ChangeNotifier {
  final SongService _songService = SongService();
  List<Song> _songs = [];
  bool _isLoading = false;

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;

  Future<void> loadSongs(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _songService.getAllSongs(token);
    } catch (e) {
      print('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  List<Song> getSongsByGenre(String genre) {
    return _songs.where((song) => song.genre == genre).toList();
  }

  Song? getSongById(String id) {
    try {
      return _songs.firstWhere((song) => song.id == id);
    } catch (e) {
      return null;
    }
  }
}