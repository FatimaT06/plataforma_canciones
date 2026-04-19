import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/user.dart';

class AuthService {
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.register));
      print('📝 Registrando en: $url');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      print('📡 Register response: ${response.statusCode}');
      print('📄 Register body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        return {
          'success': true,
          'message': data['message'],
          'user': User.fromJson(data['user']),
        };
      } else {
        final data = json.decode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Error en el registro',
        };
      }
    } catch (e) {
      print('❌ Register error: $e');
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final url = Uri.parse(ApiConfig.getFullUrl(ApiConfig.login));
      print('🔐 Login en: $url');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      print('📡 Login response status: ${response.statusCode}');
      print('📄 Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Login exitoso');
        print('🔑 Token recibido: ${data['token']?.substring(0, 20)}...');
        
        final user = User.fromJson(data['user']);
        user.token = data['token'];
        
        return {
          'success': true,
          'user': user,
          'token': data['token'],
        };
      } else {
        final data = json.decode(response.body);
        print('❌ Login fallido: ${data['message']}');
        return {
          'success': false,
          'message': data['message'] ?? 'Error en el login',
        };
      }
    } catch (e) {
      print('❌ Login error: $e');
      return {
        'success': false,
        'message': 'Error de conexión: ${e.toString()}',
      };
    }
  }
}