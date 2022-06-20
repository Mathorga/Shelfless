import 'package:hive/hive.dart';

import 'package:shelfish/models/book.dart';

@HiveType(typeId: 4)
class Library extends HiveObject {
  @HiveField(0)
  HiveList<Book> books;

  Library({
    required this.books,
  });
}
