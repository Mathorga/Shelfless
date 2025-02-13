import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';

class BookGenresBoxWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final Widget? child;
  final Book book;

  const BookGenresBoxWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.child,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare colors with custom alpha value.
    final List<Color> genreColors = book.genreIds.map((int genreId) {
      final RawGenre? genre = LibraryContentProvider.instance.genres[genreId];
      return genre != null ? Color(genre.color) : Colors.transparent;
    }).toList();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
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
      child: child,
    );
  }
}
