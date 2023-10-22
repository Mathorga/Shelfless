import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfless/models/book.dart';

class BooksProvider with ChangeNotifier {
  final Box<Book> _books = Hive.box<Book>("books");
  int Function(Book, Book)? _comparator;

  /// Returns all saved books.
  List<Book> get books {
    return _comparator != null ? [..._books.values.toList()..sort(_comparator)] : [..._books.values.toList()];
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

  /// Deletes the given book.
  void deleteBook(Book book) {
    book.delete();
    notifyListeners();
  }

  void setSorting(int Function(Book, Book) comparator) {
    _comparator = comparator;
    notifyListeners();
  }
}