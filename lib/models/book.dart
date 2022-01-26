import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(1)
  String title;

  @HiveField(2)
  HiveList<Author>? authors;

  @HiveField(3)
  int publishDate;

  @HiveField(4)
  Genre? genre;

  @HiveField(6)
  String publisher;

  @HiveField(7)
  String location;

  Book({
    this.title = "",
    this.authors,
    this.publishDate = 0,
    this.genre,
    this.publisher = "",
    this.location = "",
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "publishDate": publishDate,
      "genre": genre,
    };
  }
}
