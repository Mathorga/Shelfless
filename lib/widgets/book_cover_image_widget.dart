import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/assets.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/widgets/shaded_image_widget.dart';

/// Displays the provided book's cover image as per app settings.
class BookCoverImageWidget extends StatelessWidget {
  final Book book;
  final Widget? child;

  const BookCoverImageWidget({
    super.key,
    required this.book,
    this.child,
  });

  Widget _buildBackground(Widget child) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ColoredBox(
          color: ShelflessColors.backgroundMedium.withAlpha(0x7F),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only display child or default image if the provided book has no cover image.
    if (book.raw.cover == null) {
      return child ??
          FutureBuilder(
            // Read the default book cover from asset as UInt8List. The default cover is stored in shared prefs.
            future: rootBundle.load(Assets.defaultCovers[SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.defaultBookCoverImage) ?? Config.defaultBookCoverImage]),
            builder: (BuildContext context, AsyncSnapshot<ByteData> snapshot) {
              if (snapshot.hasError) {
                return _buildBackground(
                  Icon(
                    Icons.broken_image_rounded,
                    size: Themes.iconSizeXLarge,
                  ),
                );
              }

              if (!snapshot.hasData) {
                return _buildBackground(CircularProgressIndicator());
              }

              // Read raw data from asset.
              final Uint8List data = snapshot.data!.buffer.asUint8List();
              return ShadedImageWidget(imageData: data);
            },
          );
    }

    // Display the book's cover image otherwise.
    return ShadedImageWidget(imageData: book.raw.cover!);
  }
}
