import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<Author> authors;

  @HiveField(3)
  final int publishDate;

  @HiveField(4)
  final Genre genre;

  @HiveField(6)
  final String publisher;

  @HiveField(7)
  final String location;

  Book({
    required this.title,
    required this.authors,
    required this.publishDate,
    required this.genre,
    required this.publisher,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "publishDate": publishDate,
      "genre": genre,
    };
  }
}
