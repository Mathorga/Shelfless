import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/insert_author_screen.dart';

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
        title: const Text("Insert Book"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Title"),
              Text(_book!.title),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Authors"),
              if (_book!.authors!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _book!.authors!.map((Author author) => buildAuthorPreview(author)).toList(),
                  ),
                ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Publish date"),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(_book!.publishDate.toString()),
                ),
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Genre"),
              // DropdownButton<Genre>(items: [Genre(name: name, color: color)], onChanged: (item) {}),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Publisher"),
              const TextField(),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAuthorPreview(Author author) {
    return Card(
      margin: const EdgeInsets.all(12.0),
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
}
