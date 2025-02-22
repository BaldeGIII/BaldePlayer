import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:balde_audio/providers/audio_provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final currentSong = audioProvider.currentSong;
        if (currentSong == null) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 60,
          color: Theme.of(context).primaryColor,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${currentSong.title} - ${currentSong.artist}',
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(
                  audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (audioProvider.isPlaying) {
                    audioProvider.pause();
                  } else {
                    audioProvider.play();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
