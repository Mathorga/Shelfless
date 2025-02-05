import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unavailable_content_widget.dart';

/// Displays a book thumbnail image.
class BookThumbnailWidget extends StatelessWidget {
  final Book book;
  final bool showOutBanner;

  const BookThumbnailWidget({
    super.key,
    required this.book,
    this.showOutBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare border radius.
    const double outerRadius = Themes.radiusLarge;
    const double coverPadding = Themes.spacingSmall;
    const double innerRadius = outerRadius - coverPadding;

    // Prepare colors with custom alpha value.
    final List<Color> genreColors = book.genreIds.map((int genreId) {
      final RawGenre? genre = LibraryContentProvider.instance.genres[genreId];
      return genre != null ? Color(genre.color) : Colors.transparent;
    }).toList();

    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: genreColors.isNotEmpty
              ? genreColors.length >= 2
                  ? genreColors
                  : [
                      genreColors.first,
                      genreColors.first,
                    ]
              : [
                  Colors.transparent,
                  Colors.transparent,
                ],
        ),
      ),
      child: book.raw.cover != null
          ? Padding(
              padding: const EdgeInsets.all(coverPadding),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(innerRadius),
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
            )
          : null,
    );
  }

  Widget _buildThumbImage() {
    return Image.memory(
      book.raw.cover!,
      fit: BoxFit.cover,
      isAntiAlias: false,
      filterQuality: FilterQuality.none,
    );
  }
}
