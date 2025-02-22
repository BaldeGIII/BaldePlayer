class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String url;
  final Duration duration;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.url,
    required this.duration,
  });

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      url: map['url'],
      duration: Duration(milliseconds: map['duration']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'url': url,
      'duration': duration.inMilliseconds,
    };
  }
}
