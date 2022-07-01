import 'package:flutter/material.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/widgets/books_overview_widget.dart';

/// Wraps a BookOverviewWidget adding an appbar that displays the applied filters.
class BooksScreen extends StatelessWidget {
  static const String routeName = "/books";

  final Genre? genre;
  final Author? author;
  final StoreLocation? location;

  const BooksScreen({
    Key? key,
    this.genre,
    this.author,
    this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((genre != null ? genre!.name : "") +
            (genre != null && author != null ? " - " : "") +
            (author != null ? author.toString() : "") +
            (author != null && location != null ? " - " : "") +
            (location != null ? location!.name : "")),
      ),
      body: BooksOverviewWidget(
        filter: (Book book) =>
            (genre != null ? book.genres.contains(genre) : true) &&
            (author != null ? book.authors.contains(author) : true) &&
            (location != null ? book.location == location : true),
      ),
    );
  }
}
