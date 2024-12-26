import 'package:shelfless/utils/database_helper.dart';

class LibraryPreview {
  int? id;

  String name;

  int booksCount;

  LibraryPreview({
    this.id,
    required this.name,
    this.booksCount = 0,
  });

  LibraryPreview.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.librariesTable}_id"],
        name = map["${DatabaseHelper.librariesTable}_id"],
        booksCount = map["books_count"];
}
