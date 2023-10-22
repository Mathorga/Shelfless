import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfless/models/author.dart';

class AuthorsProvider with ChangeNotifier {
  final Box<Author> _authors = Hive.box<Author>("authors");

  /// Returns all saved authors.
  List<Author> get authors {
    return [..._authors.values.toList()];
  }

  /// Saves a author.
  void addAuthor(Author author) {
    _authors.add(author);
    notifyListeners();
  }

  /// Updates the author at the given index.
  void updateAuthor(Author author) {
    author.save();
    notifyListeners();
  }

  /// Deletes the given author.
  void deleteAuthor(Author author) {
    author.delete();
    notifyListeners();
  }
}