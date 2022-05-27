import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/book.dart';

class BooksProvider with ChangeNotifier {
  final Box<Book> _books = Hive.box<Book>("books");

  /// Returns all saved books.
  List<Book> get books {
    return [..._books.values.toList()];
  }

  /// Saves a book.
  void addBook(Book book) {
    _books.add(book);
    notifyListeners();
  }

  /// Updates the book at the given index.
  void updateBook(Book book) {
    book.save();
    notifyListeners();
  }

  /// Deletes the book at the given index.
  void deleteBook(int index) {
    _books.deleteAt(index);
    notifyListeners();
  }
}