import 'dart:io';

import 'package:path/path.dart' as p;

class AppPaths {
  AppPaths({required this.rootDir});

  final Directory rootDir;

  Directory get dbDir => Directory(p.join(rootDir.path, 'db'));
  Directory get mediaDir => Directory(p.join(rootDir.path, 'media'));
  Directory get componentsDir => Directory(p.join(mediaDir.path, 'components'));
  Directory get signaturesDir => Directory(p.join(mediaDir.path, 'signatures'));
  Directory get reportsDir => Directory(p.join(mediaDir.path, 'reports'));
  Directory get syncDir => Directory(p.join(rootDir.path, 'sync'));
  Directory get syncIncomingDir => Directory(p.join(syncDir.path, 'incoming'));
  Directory get syncOutgoingDir => Directory(p.join(syncDir.path, 'outgoing'));
  Directory get syncProcessedDir =>
      Directory(p.join(syncDir.path, 'processed'));
  Directory get syncTempDir => Directory(p.join(syncDir.path, 'temp'));
  Directory get cacheDir => Directory(p.join(rootDir.path, 'cache'));
  Directory get imageCacheDir => Directory(p.join(cacheDir.path, 'images'));
  Directory get logsDir => Directory(p.join(rootDir.path, 'logs'));

  File get databaseFile => File(p.join(dbDir.path, 'main.db'));
  File get logFile => File(p.join(logsDir.path, 'app.log'));

  Future<void> ensureCreated() async {
    final directories = [
      rootDir,
      dbDir,
      mediaDir,
      componentsDir,
      signaturesDir,
      reportsDir,
      syncDir,
      syncIncomingDir,
      syncOutgoingDir,
      syncProcessedDir,
      syncTempDir,
      cacheDir,
      imageCacheDir,
      logsDir,
    ];

    for (final directory in directories) {
      await directory.create(recursive: true);
    }
  }

  factory AppPaths.forTesting(String rootPath) {
    return AppPaths(rootDir: Directory(rootPath));
  }
}
