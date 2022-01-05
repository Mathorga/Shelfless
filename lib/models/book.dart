import 'package:shelfish/models/author.dart';

class Book {
  final String _title;
  final List<Author> _authors;
  final DateTime _publishDate;

  Book(
    this._title,
    this._authors,
    this._publishDate,
  );
}
