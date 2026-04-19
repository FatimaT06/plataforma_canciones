import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class GenreService {
  Future<List<String>> getAllGenres() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.getFullUrl(ApiConfig.genres)),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((genre) => genre.toString()).toList();
      } else {
        throw Exception('Error al cargar géneros');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }
}