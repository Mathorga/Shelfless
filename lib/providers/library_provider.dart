import 'package:flutter/foundation.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/genre.dart';
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
  Map<int, Genre> genres = {};
  Map<int, Author> authors = {};
  Map<int, Publisher> publishers = {};
  Map<int, StoreLocation> locations = {};

  /// Asks the DB for the library with the prodided [libraryId].
  void fetchLibrary(int libraryId) async {
    library = await DatabaseHelper.instance.getRawLibrary(libraryId);
    books = await DatabaseHelper.instance.getLibraryBooks(libraryId);
    // genres = await DatabaseHelper.instance.getLibraryGenres(libraryId);

    notifyListeners();
  }
}