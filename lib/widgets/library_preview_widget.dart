import 'package:flutter/material.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/library_content_provider.dart';
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

                  // Share the library to other apps.
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
