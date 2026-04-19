import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.register(name, email, password);
    
    _isLoading = false;
    notifyListeners();

    if (result['success']) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await _authService.login(email, password);
    
    if (result['success']) {
      _user = result['user'];
      _token = result['token'];
      await _saveAuthData();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('token', _token!);
    }
    if (_user != null) {
      await prefs.setString('user', _user!.toJson().toString());
    }
  }

  Future<void> loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    
    if (_token != null) {
      // Aquí podrías cargar el usuario desde el token o storage
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    _token = null;
    notifyListeners();
  }
}