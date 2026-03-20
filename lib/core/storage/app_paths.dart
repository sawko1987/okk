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
  Directory get backupDir => Directory(p.join(rootDir.path, 'backup'));

  File get databaseFile => File(p.join(dbDir.path, 'main.db'));
  File get logFile => File(p.join(logsDir.path, 'app.log'));

  String relativeToRoot(String absolutePath) {
    final normalizedPath = p.normalize(absolutePath);
    final normalizedRoot = p.normalize(rootDir.path);

    if (!p.isWithin(normalizedRoot, normalizedPath) &&
        normalizedPath != normalizedRoot) {
      throw ArgumentError.value(
        absolutePath,
        'absolutePath',
        'Path must be inside the application root directory.',
      );
    }

    return p.relative(normalizedPath, from: normalizedRoot);
  }

  String resolveRelativePath(String relativePath) {
    if (!p.isRelative(relativePath)) {
      throw ArgumentError.value(
        relativePath,
        'relativePath',
        'Only relative paths may be resolved from app_data.',
      );
    }

    return p.normalize(p.join(rootDir.path, relativePath));
  }

  String componentImageRelativePath(String componentId, String fileName) {
    return p.join('media', 'components', componentId, fileName);
  }

  String signatureRelativePath(String inspectionId, String fileName) {
    return p.join('media', 'signatures', inspectionId, fileName);
  }

  String reportRelativePath(String inspectionId, String fileName) {
    return p.join('media', 'reports', inspectionId, fileName);
  }

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
      backupDir,
    ];

    for (final directory in directories) {
      await directory.create(recursive: true);
    }
  }

  factory AppPaths.forTesting(String rootPath) {
    return AppPaths(rootDir: Directory(rootPath));
  }
}
