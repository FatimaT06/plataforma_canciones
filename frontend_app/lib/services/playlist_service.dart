import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class PlaylistService {
  Future<Map<String, dynamic>> createPlaylist(String token, String name) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.getFullUrl(ApiConfig.playlists)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': name}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'playlist': Playlist.fromJson(data['playlist']),
        };
      } else {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Error al crear playlist',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  Future<List<Playlist>> getUserPlaylists(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getFullUrl(ApiConfig.playlists)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((playlist) => Playlist.fromJson(playlist)).toList();
      } else {
        throw Exception('Error al cargar playlists');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  Future<Playlist> getPlaylistById(String token, String playlistId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.getFullUrl(ApiConfig.playlists)}/$playlistId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Playlist.fromJson(data);
      } else {
        throw Exception('Error al cargar playlist');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> addSongToPlaylist(
    String token, 
    String playlistId, 
    String songId
  ) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConfig.getFullUrl(ApiConfig.addSongToPlaylist)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'playlistId': playlistId,
          'songId': songId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al agregar canción',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> removeSongFromPlaylist(
    String token, 
    String playlistId, 
    String songId
  ) async {
    try {
      final response = await http.delete(
        Uri.parse(ApiConfig.getFullUrl(ApiConfig.removeSongFromPlaylist)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'playlistId': playlistId,
          'songId': songId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': 'Error al eliminar canción',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}