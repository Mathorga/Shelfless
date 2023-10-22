import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/books_overview_widget.dart';

/// Wraps a BooksOverviewWidget adding an appbar that displays the applied filters.
class BooksScreen extends StatelessWidget {
  static const String routeName = "/books";

  final Set<Genre> genres;
  final Set<Author> authors;
  final Publisher? publisher;
  final StoreLocation? location;

  const BooksScreen({
    Key? key,
    this.genres = const {},
    this.authors = const {},
    this.publisher,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.filteredBooksTitle),
      ),
      body: BooksOverviewWidget(
        filter: (Book book) =>
            (genres.isNotEmpty ? book.genres.any((Genre genre) => genres.contains(genre)) : true) &&
            (authors.isNotEmpty ? book.authors.any((Author author) => authors.contains(author)) : true) &&
            (publisher != null ? book.publisher == publisher : true) &&
            (location != null ? book.location == location : true),
      ),
    );
  }
}
