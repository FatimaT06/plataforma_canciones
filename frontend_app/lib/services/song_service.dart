import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/song.dart';

class SongService {
  Future<List<Song>> getAllSongs(String token) async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getFullUrl(ApiConfig.songs)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((song) => Song.fromJson(song)).toList();
      } else {
        throw Exception('Error al cargar canciones');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }
}