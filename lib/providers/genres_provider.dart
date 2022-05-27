import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/genre.dart';

class GenresProvider with ChangeNotifier {
  final Box<Genre> _genres = Hive.box<Genre>("genres");

  /// Returns all saved genres.
  List<Genre> get genres {
    return [..._genres.values.toList()];
  }

  /// Saves a genre.
  void addGenre(Genre genre) {
    _genres.add(genre);
    notifyListeners();
  }

  /// Updates the genre at the given index.
  void updateGenre(int index, Genre genre) {
    _genres.putAt(index, genre);
    notifyListeners();
  }

  /// Deletes the genre at the given index.
  void deleteGenre(int index) {
    _genres.deleteAt(index);
    notifyListeners();
  }
}