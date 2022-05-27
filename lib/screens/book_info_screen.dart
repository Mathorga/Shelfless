import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';

class BookInfoScreen extends StatefulWidget {
  static const String routeName = "/book-info";

  const BookInfoScreen({Key? key}) : super(key: key);

  @override
  State<BookInfoScreen> createState() => _BookInfoScreenState();
}

class _BookInfoScreenState extends State<BookInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch provider.
    final BooksProvider booksProvider = Provider.of(context, listen: true);

    // Fetch book.
    Book book = booksProvider.books[ModalRoute.of(context)!.settings.arguments as int];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          book.title,
          style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Authors.
              const Text("Authors"),
              if (book.authors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.authors.map((Author author) => AuthorPreviewWidget(author: author)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
              ),

              // Publish date.
              const Text("Publish date"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(book.publishDate.toString()),
              ),
              const SizedBox(
                height: 24.0,
              ),

              // Genres.
              const Text("Genres"),
              if (book.genres.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.genres.map((Genre genre) => GenrePreviewWidget(genre: genre)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
              ),

              // Publisher.
              const Text("Publisher"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(book.publisher),
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to edit_book_screen.
          Navigator.of(context).pushNamed(EditBookScreen.routeName, arguments: booksProvider.books.indexOf(book));
        },
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }
}
