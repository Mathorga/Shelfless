import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:archive/archive.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/utils/database_helper.dart';

class LibraryPreviewWidget extends StatelessWidget {
  final LibraryPreview library;

  const LibraryPreviewWidget({
    super.key,
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 100.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15.0),
              ),
              child: Image.asset(
                "assets/images/covers/bookshelf.png",
                filterQuality: FilterQuality.none,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    library.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (library.raw.id == null) return;

                  // Extract the library.
                  final Map<String, String> libraryStrings = await DatabaseHelper.instance.extractLibrary(library.raw.id!);

                  // Compress the library files to a single .slz file.
                  final Archive archive = Archive();
                  libraryStrings.entries
                      .map((MapEntry<String, String> element) => ArchiveFile(
                            "${element.key}.json",
                            element.value.length,
                            element.value.codeUnits,
                          ))
                      .forEach((ArchiveFile file) => archive.addFile(file));
                  final Uint8List encodedArchive = ZipEncoder().encodeBytes(archive);

                  // Share the library to other apps.
                  Share.shareXFiles(
                    [
                      XFile.fromData(
                        encodedArchive,
                        length: encodedArchive.length,
                        mimeType: "application/x-zip",
                      ),
                    ],
                    // The name parameter in the XFile.fromData method is ignored in most platforms,
                    // so fileNameOverrides is used instead.
                    fileNameOverrides: [
                      "${library.raw.name}.slz",
                    ],
                  );
                },
                icon: Icon(Icons.share_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
