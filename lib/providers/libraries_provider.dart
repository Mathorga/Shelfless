import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';

import 'package:shelfish/models/library.dart';

class LibrariesProvider with ChangeNotifier {
  final Box<Library> _libraries = Hive.box<Library>("libraries");
  int? _currentIndex;

  /// Returns all saved libraries.
  List<Library> get libraries {
    return [..._libraries.values.toList()];
  }

  Library? get currentLibrary {
    return _currentIndex != null ? libraries[_currentIndex!] : null;
  }

  /// Saves a library.
  void addLibrary(Library library) {
    _libraries.add(library);
    notifyListeners();
  }

  /// Updates the library at the given index.
  void updateLibrary(Library library) {
    library.save();
    notifyListeners();
  }

  /// Deletes the given library.
  void deleteLibrary(Library library) {
    // Delete all contained books first.
    for (Book book in library.books) {
      book.delete();
    }

    // Then delete the library record itself.
    library.delete();
    notifyListeners();
  }

  void setCurrenLibrary(Library library) {
    _currentIndex = _libraries.values.toList().indexOf(library);
    notifyListeners();
  }

  void setCurrenLibraryIndex(int? index) {
    _currentIndex = index;
    notifyListeners();
  }

  void addBookToCurrentLibrary(Book book) {
    currentLibrary?.books.add(book);
    updateLibrary(currentLibrary!);
  }

  /// Tells whether any book in the given library is by the given author or not.
  bool authorInCurrentLibrary(Author author) {
    return currentLibrary != null && currentLibrary!.books.any((Book book) => book.authors.contains(author));
  }
}