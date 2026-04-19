import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/recommendation_service.dart';

class RecommendationProvider with ChangeNotifier {
  final RecommendationService _recommendationService = RecommendationService();
  List<Song> _recommendations = [];
  bool _isLoading = false;

  List<Song> get recommendations => _recommendations;
  bool get isLoading => _isLoading;

  Future<void> loadRecommendations(String token, String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _recommendations = await _recommendationService.getRecommendations(token, userId);
    } catch (e) {
      print('Error loading recommendations: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}