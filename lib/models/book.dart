import 'package:shelfish/models/author.dart';

class Book {
  final String title;
  final List<Author> authors;
  final DateTime publishDate;
  final String genre;

  Book(
    this.title,
    this.authors,
    this.publishDate,
    this.genre,
  );
}
