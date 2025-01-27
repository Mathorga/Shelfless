import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';

class BookPreviewWidget extends StatelessWidget {
  final Book book;
  final void Function()? onTap;

  const BookPreviewWidget({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Prepare border radius.
    double borderRadius = 15.0;

    // Prepare colors with custom alpha value.
    final List<Color> genreColors = book.genreIds.map((int genreId) {
      final RawGenre? genre = LibraryContentProvider.instance.genres[genreId];
      return genre != null ? Color(genre.color) : Colors.transparent;
    }).toList();

    final List<Author> authors = book.authorIds
        .map((int authorId) {
          return LibraryContentProvider.instance.authors[authorId];
        })
        .nonNulls
        .toList();

    return GestureDetector(
      onTap: onTap,
      child: Column(
        spacing: Themes.spacingMedium,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: genreColors.isEmpty
                  ? const LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                      ],
                    )
                  : genreColors.length >= 2
                      ? LinearGradient(colors: genreColors)
                      : LinearGradient(
                          colors: [
                            genreColors.first,
                            genreColors.first,
                          ],
                        ),
            ),
          ),
          Column(
            spacing: Themes.spacingXSmall,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title.
              Text(
                book.raw.title,
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),

              // Authors.
              if (authors.isNotEmpty)
                authors.length <= 2
                    ? Text(authors.map((Author author) => author.toString()).reduce((String value, String element) => "$value, $element"))
                    : Text("${authors.first}, others"),
            ],
          ),
        ],
      ),
    );
  }
}
