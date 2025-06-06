import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/book_genres_box_widget.dart';

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
                child: _buildThumbImage(),
              ),
              if (overlay != null) overlay!,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbImage() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: AnimatedOpacity(
            opacity: book.raw.out ? Themes.unavailableFeatureOpacity : 1.0,
            curve: Curves.easeInCubic,
            duration: Duration(milliseconds: 200),
            child: book.raw.cover != null
                // TODO Hide this behind an app setting.
                // ? ShadedImageWidget(
                //     imageData: book.raw.cover!,
                //     upscaleWidth: 256,
                //     upscaleHeight: 256,
                //     applyFilter: true,
                //   )
                ? Image.memory(
                    book.raw.cover!,
                    fit: BoxFit.cover,
                    isAntiAlias: true,
                    filterQuality: FilterQuality.none,
                  )
                : Image.asset(
                    "assets/images/covers/flower.png",
                    fit: BoxFit.cover,
                    isAntiAlias: true,
                    filterQuality: FilterQuality.none,
                  ),
          ),
        ),
        if (book.raw.out)
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              width: double.infinity,
              height: Themes.spacingXLarge,
              color: ShelflessColors.secondary,
              child: Center(
                child: Text(strings.outLabel),
              ),
            ),
          ),
      ],
    );
  }
}
