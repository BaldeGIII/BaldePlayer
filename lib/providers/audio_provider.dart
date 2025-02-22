import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/song.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;

  AudioPlayer get audioPlayer => _audioPlayer;
  List<Song> get playlist => _playlist;
  Song? get currentSong =>
      _currentIndex >= 0 && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  bool get isPlaying => _audioPlayer.playing;
  bool get isShuffleMode => _audioPlayer.shuffleModeEnabled;
  LoopMode get loopMode => _audioPlayer.loopMode;

  AudioProvider() {
    _audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        _currentIndex = index;
        notifyListeners();
      }
    });

    _audioPlayer.playerStateStream.listen((state) {
      notifyListeners();
    });
  }

  void setPlaylist(List<Song> songs) {
    _playlist = songs;
    _audioPlayer.setAudioSource(
      ConcatenatingAudioSource(
        children:
            _playlist
                .map((song) => AudioSource.uri(Uri.parse(song.url)))
                .toList(),
      ),
      initialIndex: 0,
    );
    notifyListeners();
  }

  void play() async {
    await _audioPlayer.play();
  }

  void pause() async {
    await _audioPlayer.pause();
  }

  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void skipToNext() async {
    await _audioPlayer.seekToNext();
  }

  void skipToPrevious() async {
    await _audioPlayer.seekToPrevious();
  }

  void setVolume(double volume) {
    _audioPlayer.setVolume(volume);
  }

  void toggleShuffle() {
    _audioPlayer.setShuffleModeEnabled(!isShuffleMode);
    notifyListeners();
  }

  void toggleLoopMode() {
    final modes = LoopMode.values;
    final nextIndex = (modes.indexOf(loopMode) + 1) % modes.length;
    _audioPlayer.setLoopMode(modes[nextIndex]);
    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
