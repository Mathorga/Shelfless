import 'package:flutter/foundation.dart';

import 'package:collection/collection.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/models/library_filters.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';

enum SortOrder {
  titleAsc,
  titleDesc,
  publishYearAsc,
  publishYearDesc,
  authorsCountAsc,
  authorsCountDesc,
  genresCountAsc,
  genresCountDesc,
  publisherAsc,
  publisherDesc,
  locationAsc,
  locationDesc;

  bool get enabled => switch (this) {
        SortOrder.titleAsc => true,
        SortOrder.titleDesc => true,
        SortOrder.publishYearAsc => true,
        SortOrder.publishYearDesc => true,
        _ => false,
      };

  String label() {
    return switch (this) {
      SortOrder.titleAsc => strings.sortByTitleAsc,
      SortOrder.titleDesc => strings.sortByTitleDesc,
      SortOrder.publishYearAsc => strings.sortByPublishYearAsc,
      SortOrder.publishYearDesc => strings.sortByPublishYearDesc,
      _ => name,
    };
  }
}

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
  final List<Book> books = [];
  final Map<int?, RawGenre> genres = {};
  final Map<int?, Author> authors = {};
  final Map<int?, Publisher> publishers = {};
  final Map<int?, StoreLocation> locations = {};

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Filters.
  // ###############################################################################################################################################################################

  LibraryFilters _filters = LibraryFilters();

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  SortOrder sortOrder = SortOrder.titleAsc;

  // ###############################################################################################################################################################################
  // Content methods.
  // ###############################################################################################################################################################################

  /// Asks the DB for the library with the prodided [rawLibrary].
  Future<void> openLibrary({RawLibrary? rawLibrary}) async {
    // The provided library has no id, so just get out.
    if (rawLibrary != null && rawLibrary.id == null) return;

    library = rawLibrary;

    // Read sort order from shared preferences.
    final int? foundSortOrderIndex = SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.sortOrder);
    if (foundSortOrderIndex != null) {
      sortOrder = SortOrder.values[foundSortOrderIndex];
    }

    await _fetchLibraryContent(rawLibrary);

    _intSortBooks();

    notifyListeners();
  }

  /// Fetches and stores content from the provided [rawLibrary].
  /// Fetches from all if none is provided.
  Future<void> _fetchLibraryContent(RawLibrary? rawLibrary) async {
    // Fetch all books for the provided library.
    final List<Book> tmpBooks = await DatabaseHelper.instance.getLibraryBooks(
      rawLibrary?.id,
      titleFilter: _filters.titleFilter,
      authorsFilter: _filters.authorsFilter,
      genresFilter: _filters.genresFilter,
      publishersFilter: _filters.publishersFilter,
      locationsFilter: _filters.locationsFilter,
    );
    books.addAll(tmpBooks);

    // Fetch ALL other data.
    genres.addAll(Map.fromEntries((await DatabaseHelper.instance.getGenres()).map((RawGenre rawGenre) => MapEntry(rawGenre.id, rawGenre))));
    authors.addAll(Map.fromEntries((await DatabaseHelper.instance.getAuthors()).map((Author rawAuthor) => MapEntry(rawAuthor.id, rawAuthor))));
    publishers.addAll(Map.fromEntries((await DatabaseHelper.instance.getPublishers()).map((Publisher publisher) => MapEntry(publisher.id, publisher))));
    locations.addAll(Map.fromEntries((await DatabaseHelper.instance.getLocations()).map((StoreLocation location) => MapEntry(location.id, location))));
  }

  Future<void> storeNewBook(Book book) async {
    await DatabaseHelper.instance.insertBook(book);

    books.add(book);
    _intSortBooks();

    // Update libraries provider.
    // The library being null here is an error and should be thrown.
    LibrariesProvider.instance.refetchLibrary(library!);

    notifyListeners();
  }

  Future<void> storeBookUpdate(Book book) async {
    // Make sure the provided book is actually stored.
    final int index = books.indexWhere((Book bookCandidate) => bookCandidate.raw.id == book.raw.id);
    if (index == -1) return;

    // Update the book in DB.
    await DatabaseHelper.instance.updateBook(book);

    // Save the updated book version.
    books[index] = book;
    _intSortBooks();

    notifyListeners();
  }

  /// Moves the book to another library in DB and stores the update.
  Future<void> moveBookTo(Book book, RawLibrary toLibrary) async {
    // Fetch the source library before going on with moving.
    RawLibrary? srcLibrary = library ?? LibrariesProvider.instance.libraries.firstWhereOrNull((LibraryPreview library) => library.raw.id == book.raw.libraryId)?.raw;

    assert(srcLibrary != null, "No source library: cannot move book");

    // Update the book's library id.
    book.raw.libraryId = toLibrary.id;

    // Ask the DB to move the book.
    await DatabaseHelper.instance.moveBookTo(book, toLibrary);

    // Remove the provided book from memory if moved to another library and a specific library is actually open.
    if (library != null && toLibrary != library) books.remove(book);

    // Update libraries provider.
    LibrariesProvider.instance.refetchLibrary(srcLibrary!);
    LibrariesProvider.instance.refetchLibrary(toLibrary);

    notifyListeners();
  }

  /// Deletes the currently open library along with all its books.
  Future<void> deleteLibrary() async {
    if (library == null) return;

    // Ask the backend to remove the library.
    await DatabaseHelper.instance.deleteLibrary(library!);

    // Also remove from libraries list.
    LibrariesProvider.instance.libraries.removeWhere((LibraryPreview preview) => preview.raw == library);

    // Clear all preexisting content and open all libraries.
    clearContent();
    await openLibrary();

    notifyListeners();
  }

  Future<void> deleteBook(Book book) async {
    // Make sure the provided book is actually stored.
    final int index = books.indexOf(book);
    if (index == -1) return;

    // Delete the book in DB.
    await DatabaseHelper.instance.deleteBook(book);

    // Remove the book from local storage.
    books.removeAt(index);

    // Update libraries provider.
    // The library being null here is an error and should be thrown.
    LibrariesProvider.instance.refetchLibrary(library!);

    notifyListeners();
  }

  /// Returns true if [author] is not referenced in any book.
  Future<bool> isAuthorRogue(Author author) async {
    return await DatabaseHelper.instance.isAuthorRogue(author);
  }

  Future<void> addAuthor(Author author) async {
    // Save the provided author to DB.
    await DatabaseHelper.instance.insertAuthor(author);

    // Only save the author locally after storing it to DB.
    authors[author.id] = author;

    notifyListeners();
  }

  Future<void> updateAuthor(Author author) async {
    // Update the provided author in DB.
    await DatabaseHelper.instance.updateAuthor(author);

    notifyListeners();
  }

  /// Delete the provided author from DB.
  Future<void> deleteAuthor(Author author) async {
    await DatabaseHelper.instance.deleteAuthor(author);

    authors.remove(author.id);

    // Update library filters if the deleted author is in them.
    _filters.authorsFilter.remove(author.id);

    notifyListeners();
  }

  /// Returns true if [genre] is not referenced in any book.
  Future<bool> isGenreRogue(RawGenre genre) async {
    return await DatabaseHelper.instance.isGenreRogue(genre);
  }

  Future<void> addGenre(RawGenre rawGenre) async {
    // Save the provided genre to DB.
    await DatabaseHelper.instance.insertGenre(rawGenre);

    // Only save the author locally after storing it to DB.
    genres[rawGenre.id] = rawGenre;

    notifyListeners();
  }

  Future<void> updateGenre(RawGenre rawGenre) async {
    // Update the provided genre in DB.
    await DatabaseHelper.instance.updateGenre(rawGenre);

    notifyListeners();
  }

  /// Delete the provided genre from DB.
  Future<void> deleteGenre(RawGenre genre) async {
    await DatabaseHelper.instance.deleteGenre(genre);

    genres.remove(genre.id);

    // Update library filters if the deleted genre is in them.
    _filters.authorsFilter.remove(genre.id);

    notifyListeners();
  }

  /// Returns true if [publisher] is not referenced in any book.
  Future<bool> isPublisherRogue(Publisher publisher) async {
    return await DatabaseHelper.instance.isPublisherRogue(publisher);
  }

  Future<void> addPublisher(Publisher publisher) async {
    // Save the provided publisher to DB.
    await DatabaseHelper.instance.insertPublisher(publisher);

    // Only save the author locally after storing it to DB.
    publishers[publisher.id] = publisher;

    notifyListeners();
  }

  Future<void> updatePublisher(Publisher publisher) async {
    // Update the provided publisher in DB.
    await DatabaseHelper.instance.updatePublisher(publisher);

    notifyListeners();
  }

  /// Delete the provided publisher from DB.
  Future<void> deletePublisher(Publisher publisher) async {
    await DatabaseHelper.instance.deletePublisher(publisher);

    publishers.remove(publisher.id);

    // Update library filters if the deleted publisher is in them.
    _filters.authorsFilter.remove(publisher.id);

    notifyListeners();
  }

  /// Returns true if [location] is not referenced in any book.
  Future<bool> isLocationRogue(StoreLocation location) async {
    return await DatabaseHelper.instance.isLocationRogue(location);
  }

  Future<void> addLocation(StoreLocation location) async {
    // Save the provided location to DB.
    await DatabaseHelper.instance.insertLocation(location);

    // Only save the author locally after storing it to DB.
    locations[location.id] = location;

    notifyListeners();
  }

  Future<void> updateLocation(StoreLocation location) async {
    // Update the provided location in DB.
    await DatabaseHelper.instance.updateLocation(location);

    notifyListeners();
  }

  /// Delete the provided location from DB.
  Future<void> deleteLocation(StoreLocation location) async {
    await DatabaseHelper.instance.deleteLocation(location);

    locations.remove(location.id);

    // Update library filters if the deleted location is in them.
    _filters.authorsFilter.remove(location.id);

    notifyListeners();
  }

  Future<void> addGenresToBook(Set<int> genreIds, Book book) async {
    // Only save the relationship locally.
    book.genreIds.addAll(genreIds);

    notifyListeners();
  }

  Future<void> addAuthorsToBook(Set<int> authorIds, Book book) async {
    // Only save the relationship locally.
    book.authorIds.addAll(authorIds);

    notifyListeners();
  }

  Future<void> addPublisherToBook(int publisherId, Book book) async {
    // Only save the relationship locally.
    book.raw.publisherId = publisherId;

    notifyListeners();
  }

  Future<void> removePublisherFromBook(Book book) async {
    // Only save the relationship locally.
    book.raw.publisherId = null;

    notifyListeners();
  }

  Future<void> addLocationToBook(int locationId, Book book) async {
    // Only save the relationship locally.
    book.raw.locationId = locationId;

    notifyListeners();
  }

  Future<void> removeLocationFromBook(Book book) async {
    // Only save the relationship locally.
    book.raw.locationId = null;

    notifyListeners();
  }

  void clearContent() {
    books.clear();
    genres.clear();
    authors.clear();
    publishers.clear();
    locations.clear();
  }

  void clear() {
    library = null;

    clearContent();

    clearFilters();
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Filter methods.
  // ###############################################################################################################################################################################

  void applyFilters(LibraryFilters filters) {
    // Save filters for later use.
    _filters = filters;

    // Clear preexisting content.
    clearContent();

    // Reread content with the provided filters applied.
    openLibrary(rawLibrary: library);
  }

  LibraryFilters getFilters() => _filters;

  /// Tells whether the current library content can be edited or not.
  bool get editable => !_filters.isActive && library != null;

  void clearFilters() {
    _filters = LibraryFilters();

    notifyListeners();
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Sort methods.
  // ###############################################################################################################################################################################

  /// Sorts books according to the provided compare function.
  void sortBooks(int Function(Book a, Book b) compare) {
    books.sort(compare);

    notifyListeners();
  }

  void _intSortBooks() {
    switch (sortOrder) {
      case SortOrder.titleAsc:
        books.sort((Book a, Book b) => a.raw.title.compareTo(b.raw.title));
        break;
      case SortOrder.titleDesc:
        books.sort((Book a, Book b) => b.raw.title.compareTo(a.raw.title));
        break;
      case SortOrder.authorsCountAsc:
        books.sort((Book a, Book b) => a.authorIds.length.compareTo(b.authorIds.length));
        break;
      case SortOrder.authorsCountDesc:
        books.sort((Book a, Book b) => b.authorIds.length.compareTo(a.authorIds.length));
        break;
      case SortOrder.genresCountAsc:
        books.sort((Book a, Book b) => a.genreIds.length.compareTo(b.genreIds.length));
        break;
      case SortOrder.genresCountDesc:
        books.sort((Book a, Book b) => b.genreIds.length.compareTo(a.genreIds.length));
        break;
      case SortOrder.publishYearAsc:
        books.sort((Book a, Book b) => a.raw.publishYear.compareTo(b.raw.publishYear));
        break;
      case SortOrder.publishYearDesc:
        books.sort((Book a, Book b) => b.raw.publishYear.compareTo(a.raw.publishYear));
        break;
      case SortOrder.publisherAsc:
        books.sort((Book a, Book b) {
          final Publisher? publisherA = publishers[a.raw.publisherId];
          final Publisher? publisherB = publishers[b.raw.publisherId];

          if (publisherA == null || publisherB == null) return 1;

          return publisherA.name.compareTo(publisherB.name);
        });
        break;
      case SortOrder.publisherDesc:
        books.sort((Book a, Book b) {
          final Publisher? publisherA = publishers[a.raw.publisherId];
          final Publisher? publisherB = publishers[b.raw.publisherId];

          if (publisherA == null || publisherB == null) return 1;

          return publisherB.name.compareTo(publisherA.name);
        });
        break;
      case SortOrder.locationAsc:
        books.sort((Book a, Book b) {
          final StoreLocation? locationA = locations[a.raw.locationId];
          final StoreLocation? locationB = locations[b.raw.locationId];

          if (locationA == null || locationB == null) return 1;

          return locationA.name.compareTo(locationB.name);
        });
        break;
      case SortOrder.locationDesc:
        books.sort((Book a, Book b) {
          final StoreLocation? locationA = locations[a.raw.locationId];
          final StoreLocation? locationB = locations[b.raw.locationId];

          if (locationA == null || locationB == null) return 1;

          return locationB.name.compareTo(locationA.name);
        });
        break;
    }
  }

  /// Sorts books according to the provided sort order.
  void sortBooksBy(SortOrder order) async {
    if (order == sortOrder) return;

    sortOrder = order;

    // Store the selected sort order to ahsred preferences.
    SharedPrefsHelper.instance.setValue(SharedPrefsKeys.sortOrder, order.index);

    _intSortBooks();

    notifyListeners();
  }

  /// Compares two books by their title in ascending order.
  static int compareByTitleAsc(Book a, Book b) => a.raw.title.compareTo(b.raw.title);

  /// Compares two books by their title in descending order.
  static int compareByTitleDesc(Book a, Book b) => b.raw.title.compareTo(a.raw.title);

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################
}
