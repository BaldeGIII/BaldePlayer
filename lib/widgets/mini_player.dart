import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import 'package:just_audio/just_audio.dart'; // Add this import for LoopMode

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final song = audioProvider.currentSong;

        return Container(
          height: 85,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Song info
              if (song != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${song.title} - ${song.artist}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              // Progress bar
              StreamBuilder<Duration>(
                stream: audioProvider.audioPlayer.positionStream,
                builder: (context, snapshot) {
                  final position = snapshot.data ?? Duration.zero;
                  final duration =
                      audioProvider.audioPlayer.duration ?? Duration.zero;

                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 12,
                      ),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: position.inMilliseconds.toDouble(),
                      max: duration.inMilliseconds.toDouble(),
                      onChanged: (value) {
                        audioProvider.seek(
                          Duration(milliseconds: value.toInt()),
                        );
                      },
                    ),
                  );
                },
              ),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle),
                    onPressed: () => audioProvider.toggleShuffle(),
                    color:
                        audioProvider.isShuffleMode
                            ? Theme.of(context).colorScheme.primary
                            : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => audioProvider.skipToPrevious(),
                  ),
                  FloatingActionButton(
                    mini: true,
                    child: Icon(
                      audioProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    onPressed: () {
                      if (audioProvider.isPlaying) {
                        audioProvider.pause();
                      } else {
                        audioProvider.play();
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () => audioProvider.skipToNext(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.repeat),
                    onPressed: () => audioProvider.toggleLoopMode(),
                    color:
                        audioProvider.loopMode != LoopMode.off
                            ? Theme.of(context).colorScheme.primary
                            : null,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
