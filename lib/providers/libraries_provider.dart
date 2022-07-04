import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
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
}