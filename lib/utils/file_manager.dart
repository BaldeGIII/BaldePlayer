import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:balde_audio/models/song.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileManager {
  static Future<Song?> uploadSong() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'm4a'],
        allowMultiple: false,
        withData: true, // This ensures we get the file bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final fileName = file.name;

        // Handle file storage differently for web and desktop
        String filePath;
        if (kIsWeb) {
          // Web platform handling
          if (file.bytes == null) return null;
          // For web, we'll need to handle storage differently
          // This is a placeholder for web implementation
          return Song(
            id: const Uuid().v4(),
            title: fileName.split('.').first,
            artist: 'Unknown Artist',
            album: 'Unknown Album',
            url: '', // Web URL handling would go here
            duration: const Duration(seconds: 0),
          );
        } else {
          // Desktop platform handling
          if (file.path == null) return null;

          final appDir = await getApplicationDocumentsDirectory();
          final musicDir = Directory(path.join(appDir.path, 'music'));

          if (!await musicDir.exists()) {
            await musicDir.create(recursive: true);
          }

          final newPath = path.join(musicDir.path, fileName);
          await File(file.path!).copy(newPath);
          filePath = newPath;
        }

        return Song(
          id: const Uuid().v4(),
          title: fileName.split('.').first,
          artist: 'Unknown Artist',
          album: 'Unknown Album',
          url: filePath,
          duration: const Duration(seconds: 0),
        );
      }
    } catch (e) {
      print('Error picking file: $e');
      rethrow;
    }
    return null;
  }
}
