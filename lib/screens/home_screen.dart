import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/song_list.dart';
import '../widgets/mini_player.dart';
import '../widgets/theme_switch.dart';
import '../utils/file_manager.dart';
import '../providers/audio_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  Future<void> _pickAndUploadSong(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final song = await FileManager.uploadSong();
      if (!mounted) return;

      if (song != null) {
        final audioProvider = Provider.of<AudioProvider>(
          context,
          listen: false,
        );
        audioProvider.setPlaylist([song]);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No file selected or error adding song'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balde Player'),
        actions: const [ThemeSwitch()],
      ),
      body: const Column(
        children: [
          Expanded(child: SongList()),
          MiniPlayer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _isLoading ? null : () => _pickAndUploadSong(context),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.add),
      ),
    );
  }
}