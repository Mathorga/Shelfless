import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/widgets/book_thumbnail_widget.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.raw.title),
      ),
      body: Column(
        children: [
          // Cover.
          BookThumbnailWidget(book: book),

          // TODO The rest.
        ],
      ),
    );
  }
}
