import 'package:flutter/material.dart';
import '../models/playlist.dart';
import '../models/song.dart';
import '../services/playlist_service.dart';

class PlaylistProvider with ChangeNotifier {
  final PlaylistService _playlistService = PlaylistService();
  List<Playlist> _playlists = [];
  bool _isLoading = false;

  List<Playlist> get playlists => _playlists;
  bool get isLoading => _isLoading;

  Future<bool> createPlaylist(String token, String name) async {
    _isLoading = true;
    notifyListeners();

    final result = await _playlistService.createPlaylist(token, name);
    
    if (result['success']) {
      await loadPlaylists(token);
      _isLoading = false;
      notifyListeners();
      return true;
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> loadPlaylists(String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      _playlists = await _playlistService.getUserPlaylists(token);
    } catch (e) {
      print('Error loading playlists: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<Playlist?> getPlaylistDetails(String token, String playlistId) async {
    try {
      return await _playlistService.getPlaylistById(token, playlistId);
    } catch (e) {
      print('Error loading playlist details: $e');
      return null;
    }
  }

  Future<bool> addSongToPlaylist(String token, String playlistId, String songId) async {
    final result = await _playlistService.addSongToPlaylist(token, playlistId, songId);
    
    if (result['success']) {
      await loadPlaylists(token);
      return true;
    }
    return false;
  }

  Future<bool> removeSongFromPlaylist(String token, String playlistId, String songId) async {
    final result = await _playlistService.removeSongFromPlaylist(token, playlistId, songId);
    
    if (result['success']) {
      await loadPlaylists(token);
      return true;
    }
    return false;
  }
}