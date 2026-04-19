import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/song_service.dart';

class SongProvider with ChangeNotifier {
  final SongService _songService = SongService();
  List<Song> _songs = [];
  bool _isLoading = false;
  String? _error;

  List<Song> get songs => _songs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSongs(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _songs = await _songService.getSongs(token);
    } catch (e) {
      _error = e.toString();
      _songs = [];
    }

    _isLoading = false;
    notifyListeners();
  }
}