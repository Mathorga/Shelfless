import 'package:flutter/material.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class LibraryPreviewWidget extends StatelessWidget {
  final LibraryPreview library;

  const LibraryPreviewWidget({
    super.key,
    required this.library,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ShelflessColors.mainContentInactive,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacingMedium),
          child: Text(
            library.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
