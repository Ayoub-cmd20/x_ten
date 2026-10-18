enum FileCheck { ok, badExtension, tooLarge }

class FileRules {
  const FileRules({required this.extensions, required this.maxBytes});

  static const documents = FileRules(
    extensions: {'jpg', 'jpeg', 'png', 'pdf'},
    maxBytes: 5 * 1024 * 1024,
  );

  static const images = FileRules(
    extensions: {'jpg', 'jpeg', 'png', 'webp'},
    maxBytes: 5 * 1024 * 1024,
  );

  final Set<String> extensions;
  final int maxBytes;

  int get maxMegabytes => maxBytes ~/ (1024 * 1024);

  FileCheck check({required String fileName, required int sizeInBytes}) {
    final dot = fileName.lastIndexOf('.');
    final extension = dot == -1 ? '' : fileName.substring(dot + 1).toLowerCase();
    if (!extensions.contains(extension)) return FileCheck.badExtension;
    if (sizeInBytes > maxBytes) return FileCheck.tooLarge;
    return FileCheck.ok;
  }
}
