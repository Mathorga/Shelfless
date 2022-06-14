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
    Book book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Book Info",
          style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to edit_book_screen.
              Navigator.of(context).pushNamed(EditBookScreen.routeName, arguments: book);
            },
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {
              // Show dialog asking the user to confirm their choice.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Delete"),
                    content: const Text("Are you sure you want to delete this book?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Pop the dialog.
                          Navigator.of(context).pop();
                        },
                        child: const Text("No"),
                      ),
                      TextButton(
                        onPressed: () {
                          booksProvider.deleteBook(book);

                          // Pop the dialog.
                          Navigator.of(context).pop();

                          // Pop the info screen.
                          Navigator.of(context).pop();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title.
              const Text("Title"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(book.title, style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(
                height: 24.0,
              ),

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
                child: Text(book.publishDate.toString(), style: Theme.of(context).textTheme.headline6),
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
                child: Text(book.publisher, style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
