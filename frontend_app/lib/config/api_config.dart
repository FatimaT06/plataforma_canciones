class ApiConfig {
  static const String baseUrl = 'https://plataformacanciones-production.up.railway.app/api';
  
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  
  static const String songs = '/songs';
  
  static const String playlists = '/playlists';
  static const String addSongToPlaylist = '/playlists/add-song';
  static const String removeSongFromPlaylist = '/playlists/remove-song';
  
  static const String recommendations = '/recommendations';
  
  static const String genres = '/generos';
  
  static String getFullUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
}