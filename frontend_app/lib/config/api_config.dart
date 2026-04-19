class ApiConfig {
  // Asegúrate que esta URL sea correcta
  static const String baseUrl = 'https://plataformacanciones-production.up.railway.app/api';
  
  // Auth endpoints
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  
  // Songs endpoints
  static const String songs = '/songs';
  
  // Playlists endpoints
  static const String playlists = '/playlists';
  static const String addSongToPlaylist = '/playlists/add-song';
  static const String removeSongFromPlaylist = '/playlists/remove-song';
  
  // Recommendations
  static const String recommendations = '/recommendations';
  
  // Genres
  static const String genres = '/generos';
  
  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}