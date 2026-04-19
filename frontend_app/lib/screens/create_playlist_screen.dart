import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/playlist_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../utils/color_constants.dart';

class CreatePlaylistScreen extends StatefulWidget {
  @override
  _CreatePlaylistScreenState createState() => _CreatePlaylistScreenState();
}

class _CreatePlaylistScreenState extends State<CreatePlaylistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Playlist'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.playlist_add,
              size: 100,
              color: AppColors.primary,
            ),
            SizedBox(height: 32),
            Text(
              'Nombre de la playlist',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ej: Mis favoritas',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                return null;
              },
            ),
            SizedBox(height: 32),
            Consumer<PlaylistProvider>(
              builder: (context, playlistProvider, child) {
                return CustomButton(
                  text: 'Crear Playlist',
                  isLoading: playlistProvider.isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final authProvider = Provider.of<AuthProvider>(context, listen: false);
                      
                      if (authProvider.token != null) {
                        final success = await playlistProvider.createPlaylist(
                          authProvider.token!,
                          _nameController.text,
                        );
                        
                        if (success) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Playlist creada exitosamente'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error al crear playlist'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}