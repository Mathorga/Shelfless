import 'package:flutter/material.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/publisher.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/widgets/books_overview_widget.dart';

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
        title: Text("Filtered books"),
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
