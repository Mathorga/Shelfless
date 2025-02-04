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
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            library.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
