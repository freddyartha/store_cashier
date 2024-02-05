import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

enum FileDocumentType {
  jpg,
  jpeg,
  png,
  pdf,
}

extension FileDocumentTypeExtension on FileDocumentType {
  String get extension {
    switch (this) {
      case FileDocumentType.jpeg:
        return ".jpeg";
      case FileDocumentType.jpg:
        return ".jpg";
      case FileDocumentType.png:
        return ".png";
      case FileDocumentType.pdf:
        return ".pdf";
      default:
        return "N/A";
    }
  }
}

bool isExtesionPdf(String path) {
  File file = File(path);
  String fileExtension = p.extension(file.path);
  return fileExtension == FileDocumentType.pdf.extension;
}
