import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/raw_genre.dart';

class BookPreviewWidget extends StatelessWidget {
  final Book book;
  final void Function()? onTap;

  const BookPreviewWidget({
    Key? key,
    required this.book,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Prepare border radius.
    double borderRadius = 15.0;

    // Prepare colors with custom alpha value.
    // List<Color> genreColors = book.genres.map((Genre genre) => Color(genre.color)).toList();
    List<Color> genreColors = [
      Colors.red,
      Colors.amber,
    ];

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.transparent,
        child: Container(
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
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title.
                Text(
                  book.raw.title,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12.0),

                // Authors.
                // if (book.authors.isNotEmpty)
                //   book.authors.length <= 2
                //       ? Text(book.authors
                //           .map((Author author) => author.toString())
                //           .reduce((String value, String element) =>
                //               "$value, $element"))
                //       : Text("${book.authors.first}, others"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
