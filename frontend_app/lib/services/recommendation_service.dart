import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/song.dart';

class RecommendationService {
  Future<List<Song>> getRecommendations(String token, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.getFullUrl(ApiConfig.recommendations)}/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((song) => Song.fromJson(song)).toList();
      } else {
        throw Exception('Error al cargar recomendaciones');
      }
    } catch (e) {
      throw Exception('Error de conexión: ${e.toString()}');
    }
  }
}