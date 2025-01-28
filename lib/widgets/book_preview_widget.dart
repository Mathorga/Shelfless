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
    const double outerRadius = Themes.radiusLarge;
    const double coverPadding = Themes.spacingSmall;
    const double innerRadius = outerRadius - coverPadding;

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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
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
                      child: Image.memory(
                        book.raw.cover!,
                        fit: BoxFit.cover,
                        isAntiAlias: false,
                        filterQuality: FilterQuality.none,
                      ),
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Themes.spacingSmall),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: Themes.spacingXSmall,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Title.
                      Text(
                        book.raw.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                      ),

                      // Authors.
                      if (authors.isNotEmpty)
                        Text(
                          authors.length <= 2
                              ? authors.map((Author author) => author.toString()).reduce((String value, String element) => "$value, $element")
                              : "${authors.first}, others",
                          style: Theme.of(context).textTheme.labelMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
