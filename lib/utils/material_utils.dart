import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/library_preview_widget.dart';

class MaterialUtils {
  static void moveBookTo(BuildContext context, {required Book book}) {
    // There's no other library, so let the user know the book cannot be moved anywhere.
    if (LibrariesProvider.instance.libraries.length <= 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(strings.genericInfo),
          content: Text(strings.bookMoveToNoLibrary),
        ),
      );
      return;
    }

    // Get all libraries excluding the currently open one.
    final Iterable<LibraryPreview> libraries =
        LibrariesProvider.instance.libraries.where((LibraryPreview libraryPreview) => libraryPreview.raw != LibraryContentProvider.instance.library);

    // Let the user pick the library to move the book to.
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(strings.bookMoveTo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Themes.spacingSmall,
          children: [
            Text(strings.bookMoveToDescription),
            SingleChildScrollView(
              physics: Themes.scrollPhysics,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: libraries
                    .map((LibraryPreview libraryPreview) => GestureDetector(
                          onTap: () {
                            final NavigatorState navigator = Navigator.of(context);

                            // Move the book to the selected library.
                            LibraryContentProvider.instance.moveBookTo(book, libraryPreview.raw);

                            navigator.pop();
                          },
                          child: LibraryPreviewWidget(library: libraryPreview),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
