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

  /// Updates the given genre.
  void updateGenre(Genre genre) {
    genre.save();
    notifyListeners();
  }

  /// Deletes the given genre.
  void deleteGenre(Genre genre) {
    genre.delete();
    notifyListeners();
  }
}