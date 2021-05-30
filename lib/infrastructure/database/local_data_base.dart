import 'dart:async';

import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

import 'directory_util.dart';

class LocalDatabase {
  static const String UmmadumDB = 'UmmadumDB.db';
  final DirectoryUtil plaform;
  final Completer<Database> _dbOpenCompleter = Completer();

  LocalDatabase(this.plaform) {
    _openDatabase();
  }

  Future<Database> get database async {
    return _dbOpenCompleter.future;
  }

  Future _openDatabase() async {
    final platformDir = await plaform.platformDirectory;
    final dbPath = join(platformDir.path, UmmadumDB);
    final database = await databaseFactoryIo.openDatabase(dbPath, version: 1);
    _dbOpenCompleter.complete(database);
  }
}
