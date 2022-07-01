import 'package:hive/hive.dart';

import 'package:shelfish/models/book.dart';

part 'library.g.dart';

@HiveType(typeId: 4)
class Library extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Book> books;

  Library({
    required this.name,
    required this.books,
  });

  @override
  String toString() {
    return "$name (${books.toList().length} books)";
  }
}