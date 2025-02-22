import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:balde_audio/models/song.dart';
import 'package:balde_audio/repositories/song_respository.dart';
import 'package:uuid/uuid.dart';

class FileManager {
  static final SongRepository _songRepository = SongRepository();

  static Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  static Future<Song?> uploadSong() async {
    if (!await requestPermissions()) {
      throw Exception('Storage permission not granted');
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String fileName = result.files.single.name;

      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      String newPath = '$appDocPath/$fileName';

      await file.copy(newPath);

      Song song = Song(
        id: const Uuid().v4(),
        title: fileName.split('.').first,
        artist: 'Unknown Artist',
        album: 'Unknown Album',
        url: newPath,
        duration: const Duration(
          seconds: 0,
        ), // You may want to get the actual duration
      );

      await _songRepository.insertSong(song);
      return song;
    }

    return null;
  }
}
