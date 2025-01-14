import 'package:flutter/foundation.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/utils/database_helper.dart';

class LibraryContentProvider with ChangeNotifier {
  // Private instance.
  static final LibraryContentProvider _instance = LibraryContentProvider._private();

  // Private constructor.
  LibraryContentProvider._private();

  // Public instance getter.
  static LibraryContentProvider get instance => _instance;

  // ###############################################################################################################################################################################
  // Content.
  // ###############################################################################################################################################################################

  RawLibrary? library;
  List<Book> books = [];
  Map<int?, RawGenre> genres = {};
  Map<int?, Author> authors = {};
  Map<int?, Publisher> publishers = {};
  Map<int?, StoreLocation> locations = {};

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Filters.
  // ###############################################################################################################################################################################

  String? titleFilter;
  Set<int?> genresFilter = {};
  Set<int?> authorsFilter = {};
  Set<int?> publishersFilter = {};
  Set<int?> locationsFilter = {};
  int? startYearFilter;
  int? endYearFilter;

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

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

  List<RawGenre> getBookAuthors(Book book) {
    // TODO
    return [];
  }

  void storeNewBook(Book book) async {
    await DatabaseHelper.instance.insertBook(book);

    books.add(book);

    notifyListeners();
  }

  void storeBookUpdate(Book book) async {
    await DatabaseHelper.instance.updateBook(book);

    notifyListeners();
  }

  void addAuthor(Author author) async {
    // Save the provided author to DB.
    await DatabaseHelper.instance.insertAuthor(author);

    // Only save the author locally after storing it to DB.
    authors[author.id] = author;

    notifyListeners();
  }

  void updateAuthor(Author author) async {
    // Update the provided author in DB.
    await DatabaseHelper.instance.updateAuthor(author);

    notifyListeners();
  }

  void addGenre(RawGenre rawGenre) async {
    // Save the provided genre to DB.
    await DatabaseHelper.instance.insertGenre(rawGenre);

    // Only save the author locally after storing it to DB.
    genres[rawGenre.id] = rawGenre;

    notifyListeners();
  }

  void updateGenre(RawGenre rawGenre) async {
    // Update the provided genre in DB.
    await DatabaseHelper.instance.updateGenre(rawGenre);

    notifyListeners();
  }

  void addPublisher(Publisher publisher) async {
    // Save the provided publisher to DB.
    await DatabaseHelper.instance.insertPublisher(publisher);

    // Only save the author locally after storing it to DB.
    publishers[publisher.id] = publisher;

    notifyListeners();
  }

  void updatePublisher(Publisher publisher) async {
    // Update the provided publisher in DB.
    await DatabaseHelper.instance.updatePublisher(publisher);

    notifyListeners();
  }

  void addGenresToBook(Set<int> genreIds, Book book) async {
    // Only save the relationship locally.
    book.genreIds.addAll(genreIds);

    notifyListeners();
  }

  void addAuthorsToBook(Set<int> authorIds, Book book) async {
    // Only save the relationship locally.
    book.authorIds.addAll(authorIds);

    notifyListeners();
  }

  void addPublisherToBook(int publisherId, Book book) async {
    // Only save the relationship locally.
    book.raw.publisherId = publisherId;

    notifyListeners();
  }
}
