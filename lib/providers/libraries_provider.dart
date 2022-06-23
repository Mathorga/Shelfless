import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/library.dart';

class LibrariesProvider with ChangeNotifier {
  final Box<Library> _libraries = Hive.box<Library>("libraries");

  /// Returns all saved libraries.
  List<Library> get libraries {
    return [..._libraries.values.toList()];
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
}