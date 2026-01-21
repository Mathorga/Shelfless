import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';

import 'package:shelfless/utils/constants.dart';

class Utils {
  static int randomColor() => (Random().nextDouble() * 0x00FFFFFF + 0xFF000000).toInt();

  static Future<Map<String, String>> pickLibrary() async {
    // Let the user pick the library file.
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result == null) throw Exception();

    final String? fileName = result.names.single;

    if (fileName == null) {
      // TODO Let the user know an error occurred.
      throw Exception();
    }

    if (!fileName.endsWith(libraryFileFormat)) {
      // TODO Let the user know they picked the wrong file type.
      throw Exception();
    }

    File file = File(result.files.single.path!);
    final Uint8List fileData = file.readAsBytesSync();

    // Decompress the library file.
    final Archive archive = ZipDecoder().decodeBytes(fileData);

    final Map<String, String> libraryStrings = Map.fromEntries(archive.map((ArchiveFile archiveFile) {
      // final File entryFile = File(archiveFile.);
      String fileName = archiveFile.name.split(".").first;
      String fileContent = String.fromCharCodes(archiveFile.readBytes()!.toList());
      return MapEntry(fileName, fileContent);
    }));

    // Make sure the provided data contains db info.
    if (!libraryStrings.containsKey("db_info")) {
      // TODO Let the user know the provided file is invalid.
      throw Exception();
    }

    return libraryStrings;
  }
}
