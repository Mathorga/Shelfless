import 'package:flutter/material.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';

class BookInfoScreen extends StatefulWidget {
  static const String routeName = "/book-info";

  const BookInfoScreen({Key? key}) : super(key: key);

  @override
  State<BookInfoScreen> createState() => _BookInfoScreenState();
}

class _BookInfoScreenState extends State<BookInfoScreen> {
  Book? _book;

  @override
  Widget build(BuildContext context) {
    _book = ModalRoute.of(context)!.settings.arguments as Book;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _book!.title,
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
              if (_book!.authors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _book!.authors.map((Author author) => _buildAuthorPreview(author)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
              ),

              // Publish date.
              const Text("Publish date"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_book!.publishDate.toString()),
              ),
              const SizedBox(
                height: 24.0,
              ),

              // Genres.
              const Text("Genres"),
              if (_book!.genres.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _book!.genres.map((Genre genre) => _buildGenrePreview(genre)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
              ),

              // Publisher.
              const Text("Publisher"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(_book!.publisher),
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
          // TODO Navigate to edit_book_screen.
        },
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _buildAuthorPreview(Author author) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${author.firstName} ${author.lastName}",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenrePreview(Genre genre) {
    return Card(
      color: Color(genre.color).withAlpha(0x55),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              genre.name,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
