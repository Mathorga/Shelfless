import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/store_location.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(1)
  String title;

  @HiveField(2)
  HiveList<Author> authors;

  @HiveField(3)
  int publishDate;

  @HiveField(4)
  HiveList<Genre> genres;

  @HiveField(6)
  String publisher;

  @HiveField(7)
  StoreLocation? location;

  Book({
    this.title = "",
    required this.authors,
    this.publishDate = 0,
    required this.genres,
    this.publisher = "",
    this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "publishDate": publishDate,
      "publisher": publisher,
    };
  }
}
