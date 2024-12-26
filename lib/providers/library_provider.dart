import 'package:flutter/foundation.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library.dart';
import 'package:shelfless/utils/database_helper.dart';

class LibraryProvider with ChangeNotifier {
  // Private instance.
  static final LibraryProvider _instance = LibraryProvider._private();

  // Private constructor.
  LibraryProvider._private();

  // Public instance getter.
  static LibraryProvider get instance => _instance;

  Library? library;

  /// Asks the DB for the library with the prodided [id].
  static void fetchLibrary(int id) {
    DatabaseHelper.instance.fetchLibrary(id);
  }
}