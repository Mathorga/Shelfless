import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/widgets/book_cover_image_widget.dart';
import 'package:shelfless/widgets/colored_border_widget.dart';

/// Displays a book thumbnail image.
class BookThumbnailWidget extends StatelessWidget {
  final Book book;
  final Widget? overlay;

  const BookThumbnailWidget({
    super.key,
    required this.book,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare colors with custom alpha value.
    final List<Color> genreColors = book.genreIds.map((int genreId) {
      final RawGenre? genre = LibraryContentProvider.instance.genres[genreId];
      return genre != null ? Color(genre.color) : Colors.transparent;
    }).toList();

    return ColoredBorderWidget(
      width: Themes.thumbnailSizeMedium,
      height: Themes.thumbnailSizeMedium,
      borderRadius: Themes.radiusLarge,
      colors: genreColors,
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
            duration: Themes.durationXXShort,
            child: BookCoverImageWidget(book: book),
          ),
        ),
        if (book.raw.out)
          Positioned(
            bottom: Themes.spacingSmall,
            right: Themes.spacingSmall,
            child: Icon(
              Icons.do_disturb_alt_rounded,
            ),
          ),
      ],
    );
  }
}
