import 'package:flutter/foundation.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/utils/database_helper.dart';

class LibraryProvider with ChangeNotifier {
  // Private instance.
  static final LibraryProvider _instance = LibraryProvider._private();

  // Private constructor.
  LibraryProvider._private();

  // Public instance getter.
  static LibraryProvider get instance => _instance;

  RawLibrary? library;
  List<Book> books = [];
  Map<int?, RawGenre> genres = {};
  Map<int?, Author> authors = {};
  Map<int?, Publisher> publishers = {};
  Map<int?, StoreLocation> locations = {};

  /// Asks the DB for the library with the prodided [libraryId].
  void fetchLibraryContent(RawLibrary rawLibrary) async {
    library = rawLibrary;

    if (rawLibrary.id == null) return;

    // Fetch all books for the provided library.
    books = await DatabaseHelper.instance.getLibraryBooks(rawLibrary.id!);

    // Fetch ALL other data.
    genres = Map.fromEntries((await DatabaseHelper.instance.getGenres()).map((RawGenre rawGenre) => MapEntry(rawGenre.id, rawGenre)));
    authors = Map.fromEntries((await DatabaseHelper.instance.getAuthors()).map((Author rawAuthor) => MapEntry(rawAuthor.id, rawAuthor)));

    notifyListeners();
  }

  List<Author> getBookAuthors(Book book) {
    // TODO implement.
    return [];
  }

  void addAuthor(Author author) {
    authors[author.id] = author;

    notifyListeners();
  }
}
