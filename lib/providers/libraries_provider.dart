import 'package:flutter/foundation.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/utils/database_helper.dart';

/// Holds all library previews and offers methods for CRUDing libraries.
class LibrariesProvider with ChangeNotifier {
  // Private instance.
  static final LibrariesProvider _instance = LibrariesProvider._private();

  // Private constructor.
  LibrariesProvider._private();

  // Public instance getter.
  static LibrariesProvider get instance => _instance;

  List<LibraryPreview> libraries = [];

  int get totalBooksCount => libraries.map((LibraryPreview libraryPreview) => libraryPreview.booksCount).reduce((value, element) => value + element);

  /// Asks the DB for all libraries and stores them for later use.
  Future<void> fetchLibraries() async {
    libraries.addAll(await DatabaseHelper.instance.getLibraries());

    notifyListeners();
  }

  /// Refetches a single library in order to update listeners.
  Future<void> refetchLibrary(RawLibrary library) async {
    final int libraryIndex = libraries.indexWhere((LibraryPreview libPreview) => libPreview.raw == library);

    if (libraryIndex <= -1) return;

    final LibraryPreview refetchedLib = await DatabaseHelper.instance.getLibrary(library.id);

    libraries[libraryIndex] = refetchedLib;

    notifyListeners();
  }

  Future<void> addLibrary(LibraryPreview libraryPreview) async {
    // Save the library to DB.
    await DatabaseHelper.instance.insertRawLibrary(libraryPreview.raw);

    // Store the library in memory.
    libraries.add(libraryPreview);

    notifyListeners();
  }

  Future<void> updateLibrary(LibraryPreview libraryPreview) async {
    await DatabaseHelper.instance.updateRawLibrary(libraryPreview.raw);

    notifyListeners();
  }

  Future<void> deleteLibrary(LibraryPreview libraryPreview) async {
    // TODO Also delete all books related to the provided library id.
    await DatabaseHelper.instance.deleteRawLibrary(libraryPreview.raw);

    libraries.remove(libraryPreview);

    notifyListeners();
  }
}