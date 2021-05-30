import 'dart:io';

import 'package:file/file.dart' as f;
import 'package:file/local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DirectoryUtil {
  DirectoryUtil();

  static const CACHE_FOLDER = 'imageCache';

  Future<f.Directory> get imageCacheDirectory async => _createDirectory(CACHE_FOLDER);

  Future<Directory> get platformDirectory =>
      Platform.isAndroid ? getApplicationDocumentsDirectory() : getLibraryDirectory();

  Future<f.Directory> _createDirectory(String folder) async {
    final path = (await platformDirectory).path;
    const fileSystem = LocalFileSystem();
    final cachePath = join(path, folder);
    return fileSystem.directory(cachePath).create(recursive: true);
  }
}
