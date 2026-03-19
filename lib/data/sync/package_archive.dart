import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageArchive {
  Future<File> zipDirectory({
    required Directory sourceDirectory,
    required File destinationFile,
  }) async {
    if (!await sourceDirectory.exists()) {
      throw StateError('Source directory does not exist: ${sourceDirectory.path}');
    }

    await destinationFile.parent.create(recursive: true);
    if (await destinationFile.exists()) {
      await destinationFile.delete();
    }

    final encoder = ZipFileEncoder();
    encoder.create(destinationFile.path);
    encoder.addDirectory(sourceDirectory, includeDirName: false);
    encoder.close();
    return destinationFile;
  }

  Future<Directory> unzipFile({
    required File sourceFile,
    required Directory destinationDirectory,
  }) async {
    if (!await sourceFile.exists()) {
      throw StateError('Archive does not exist: ${sourceFile.path}');
    }

    if (await destinationDirectory.exists()) {
      await destinationDirectory.delete(recursive: true);
    }
    await destinationDirectory.create(recursive: true);

    final input = InputFileStream(sourceFile.path);
    try {
      final archive = ZipDecoder().decodeBuffer(input);
      await extractArchiveToDisk(archive, destinationDirectory.path);
    } finally {
      input.close();
    }
    return destinationDirectory;
  }
}

final packageArchiveProvider = Provider<PackageArchive>(
  (ref) => PackageArchive(),
);
