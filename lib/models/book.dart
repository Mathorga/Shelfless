import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';

class Book {
  final String title;
  final List<Author> authors;
  final DateTime publishDate;
  final Genre genre;
  final String publisher;
  final String location;

  Book(
    this.title,
    this.authors,
    this.publishDate,
    this.genre,
    this.publisher,
    this.location,
  );
}
