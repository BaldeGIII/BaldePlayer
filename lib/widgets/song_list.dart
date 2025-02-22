import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balde_audio/providers/audio_provider.dart';
import '../models/song.dart';

class SongList extends StatelessWidget {
  const SongList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        return ListView.builder(
          itemCount: audioProvider.playlist.length,
          itemBuilder: (context, index) {
            final song = audioProvider.playlist[index];
            return ListTile(
              title: Text(song.title),
              subtitle: Text(song.artist),
              leading: const Icon(Icons.music_note),
              onTap: () {
                audioProvider.audioPlayer.seek(Duration.zero, index: index);
                audioProvider.play();
              },
            );
          },
        );
      },
    );
  }
}
