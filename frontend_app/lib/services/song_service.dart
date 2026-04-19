import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class SongService {
  static const String baseUrl = 'https://plataformacanciones-production.up.railway.app/api';

  Future<List<Song>> getSongs(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/songs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Song> songs = data.map((json) => Song.fromJson(json)).toList();
        print('Canciones cargadas: ${songs.length}');
        return songs;
      } else {
        throw Exception('Error al cargar canciones: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}