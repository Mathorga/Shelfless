import 'package:shelfless/models/book.dart';
import 'package:shelfless/utils/database_helper.dart';

class Library {
  int? id;

  String name;

  List<Book> books;

  Library({
    this.id,
    required this.name,
    this.books = const [],
  });

  Map<String, dynamic> toMap() => {
    "${DatabaseHelper.librariesTable}_id": id,
    "${DatabaseHelper.librariesTable}_name": name,
  };

  /// Creates and returns a copy of [this].
  Library copy() {
    return Library(
      name: name,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Library other) {
    name = other.name;
  }

  @override
  String toString() {
    return name;
  }
}
