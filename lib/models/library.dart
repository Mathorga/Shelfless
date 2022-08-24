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

  Library.fromCsvString({required this.name, required String csvString}) : books = HiveList(Hive.box<Book>("books")) {
    // Separate csv lines: each line is a book.
    final List<String> lines = csvString.split("\n");

    // The first line is skipped, as it's just a header.
    lines.forEach((String bookString) {
      // Separate book fields.
      final List<String> fields = bookString.split(";");

      // TODO Get authors, create them if not already present.

      // TODO Get genres, create them if not already present.

      // TODO Get store location, create it if not already present.

      // TODO Create the book using retrieved fields.
      // books.add(Book(title: fields[0], ));
    });
  }

  List<Map<String, String>> get bookMaps {
    return books.map((Book book) => book.toMap()).toList();
  }

  String toCsvString() {
    const String header = "title;authors;publishDate;genres;publisher;location";

    return bookMaps.map<String>((Map<String, String> bookMap) {
      return bookMap.values.reduce((String value, String element) {
        // Concat multiple fields.
        return "$value;$element";
      });
    }).fold(header, (String value, String element) {
      // Concat multiple lines.
      return "$value\n$element";
    });
  }

  @override
  String toString() {
    return "$name (${books.toList().length} books)";
  }
}
