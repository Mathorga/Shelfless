import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/book_genres_box_widget.dart';
import 'package:shelfless/widgets/shaded_image_widget.dart';
import 'package:shelfless/widgets/unavailable_content_widget.dart';

/// Displays a book thumbnail image.
class BookThumbnailWidget extends StatelessWidget {
  final Book book;
  final bool showOutBanner;
  final Widget? overlay;

  const BookThumbnailWidget({
    super.key,
    required this.book,
    this.showOutBanner = false,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare border radius.
    const double outerRadius = Themes.radiusLarge;
    const double coverPadding = Themes.spacingSmall;
    const double innerRadius = outerRadius - coverPadding;

    return BookGenresBoxWidget(
      width: 200.0,
      height: 200.0,
      borderRadius: BorderRadius.circular(outerRadius),
      book: book,
      child: Padding(
        padding: const EdgeInsets.all(coverPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: book.raw.out && showOutBanner
                    ? Banner(
                        message: strings.outLabel,
                        location: BannerLocation.topEnd,
                        color: ShelflessColors.secondary,
                        child: UnavailableContentWidget(
                          child: _buildThumbImage(),
                        ),
                      )
                    : _buildThumbImage(),
              ),
              if (overlay != null) overlay!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbImage() {
    // return ShadedImageWidget(
    //   imageData: book.raw.cover!,
    // );
    return book.raw.cover != null
        ? Image.memory(
            book.raw.cover!,
            fit: BoxFit.cover,
            isAntiAlias: false,
            filterQuality: FilterQuality.none,
          )
        : Container(
            width: double.infinity,
            height: double.infinity,
            color: ShelflessColors.error,
            child: Center(
              child: Text(
                "TODO PLACE STOCK IMAGE HERE",
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
