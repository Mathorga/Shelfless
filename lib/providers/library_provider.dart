import 'package:flutter/foundation.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library.dart';

class LibraryProvider with ChangeNotifier {
  // Private instance.
  static final LibraryProvider _instance = LibraryProvider._private();

  // Private constructor.
  LibraryProvider._private();

  // Public instance getter.
  static LibraryProvider get instance => _instance;

  Library? library;
}