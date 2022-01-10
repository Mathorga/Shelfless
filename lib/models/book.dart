import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';

@HiveType(typeId: 0)
class Book {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final List<Author> authors;
  
  @HiveField(3)
  final DateTime publishDate;
  
  @HiveField(4)
  final Genre? genre;
  
  @HiveField(5)
  final GenreEnum genreEnum;
  
  @HiveField(6)
  final String publisher;
  
  @HiveField(7)
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
