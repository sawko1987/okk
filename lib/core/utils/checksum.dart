import 'dart:io';

const int _fnv32Prime = 16777619;
const int _fnv32OffsetBasis = 2166136261;
const int _uint32Mask = 0xFFFFFFFF;

String checksumBytes(List<int> bytes) {
  var hash = _fnv32OffsetBasis;

  for (final byte in bytes) {
    hash ^= byte & 0xff;
    hash = (hash * _fnv32Prime) & _uint32Mask;
  }

  return hash.toRadixString(16).padLeft(8, '0');
}

Future<String> checksumFile(File file) async {
  var hash = _fnv32OffsetBasis;

  await for (final chunk in file.openRead()) {
    for (final byte in chunk) {
      hash ^= byte & 0xff;
      hash = (hash * _fnv32Prime) & _uint32Mask;
    }
  }

  return hash.toRadixString(16).padLeft(8, '0');
}
