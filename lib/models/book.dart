import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';

class Book {
  final int id;
  final String title;
  final List<Author> authors;
  final DateTime publishDate;
  final Genre? genre;
  final GenreEnum genreEnum;
  final String publisher;
  final String location;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.publishDate,
    this.genre,
    required this.genreEnum,
    required this.publisher,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "publishDate": publishDate.year,
      "genre": genre,
    };
  }
}
