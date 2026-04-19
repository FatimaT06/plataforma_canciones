import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/song_provider.dart';
import '../providers/playlist_provider.dart';
import '../models/song.dart';
import '../widgets/song_card.dart';
import '../widgets/loading_widget.dart';
import '../utils/color_constants.dart';
import 'player_screen.dart';
import 'playlist_screen.dart';
import 'recommendations_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    SongsScreen(),
    PlaylistsScreen(),
    RecommendationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Music App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Canciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play),
            label: 'Mis Playlists',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: 'Recomendaciones',
          ),
        ],
      ),
    );
  }
}

class SongsScreen extends StatefulWidget {
  @override
  _SongsScreenState createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  String _selectedGenre = 'Todos';
  List<String> _genres = ['Todos'];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadGenres();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    
    if (authProvider.token != null) {
      await songProvider.loadSongs(authProvider.token!);
    }
  }

  Future<void> _loadGenres() async {
    final songProvider = Provider.of<SongProvider>(context, listen: false);
    // Extraer géneros únicos de las canciones
    final genres = songProvider.songs.map((s) => s.genre).toSet().toList();
    setState(() {
      _genres = ['Todos', ...genres];
    });
  }

  List<Song> get _filteredSongs {
    final songProvider = Provider.of<SongProvider>(context);
    List<Song> filtered = songProvider.songs;
    
    // Filtrar por género
    if (_selectedGenre != 'Todos') {
      filtered = filtered.where((song) => song.genre == _selectedGenre).toList();
    }
    
    // Filtrar por búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((song) =>
        song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        song.artist.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Column(
      children: [
        // Barra de búsqueda
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar canciones...',
              prefixIcon: Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
        ),
        
        // Filtro de géneros
        Container(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _genres.length,
            itemBuilder: (context, index) {
              final genre = _genres[index];
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(genre),
                  selected: _selectedGenre == genre,
                  onSelected: (selected) {
                    setState(() {
                      _selectedGenre = genre;
                    });
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: _selectedGenre == genre ? AppColors.primary : Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
        
        // Lista de canciones
        Expanded(
          child: songProvider.isLoading
              ? LoadingWidget()
              : _filteredSongs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No hay canciones disponibles',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredSongs.length,
                      itemBuilder: (context, index) {
                        final song = _filteredSongs[index];
                        return SongCard(
                          song: song,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerScreen(
                                  songs: _filteredSongs,
                                  initialIndex: index,
                                  playlistId: null,
                                ),
                              ),
                            );
                          },
                          trailingIcon: Icons.playlist_add,
                          onTrailingTap: () {
                            _showAddToPlaylistDialog(context, authProvider.token!, song.id);
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
  
  void _showAddToPlaylistDialog(BuildContext context, String token, String songId) {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Agregar a playlist',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              if (playlistProvider.playlists.isEmpty)
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No tienes playlists creadas'),
                )
              else
                ...playlistProvider.playlists.map((playlist) {
                  return ListTile(
                    leading: Icon(Icons.playlist_play, color: AppColors.primary),
                    title: Text(playlist.name),
                    subtitle: Text('${playlist.songs.length} canciones'),
                    onTap: () async {
                      Navigator.pop(context);
                      final success = await playlistProvider.addSongToPlaylist(
                        token,
                        playlist.id,
                        songId,
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            success
                                ? 'Canción agregada a ${playlist.name}'
                                : 'Error al agregar canción',
                          ),
                          backgroundColor: success ? Colors.green : Colors.red,
                        ),
                      );
                    },
                  );
                }),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}