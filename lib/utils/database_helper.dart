import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:collection/collection.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:sqflite/sqflite.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/models/library_preview.dart';

class DatabaseHelper {
  // Private instance.
  static final DatabaseHelper _instance = DatabaseHelper._private();

  // Private constructor.
  DatabaseHelper._private();

  // Public instance getter.
  static DatabaseHelper get instance => _instance;

  late Database _db;

  // ###############################################################################################################################################################################
  // Table names.
  // ###############################################################################################################################################################################

  static const String librariesTable = "libraries";
  static const String booksTable = "books";
  static const String authorsTable = "authors";
  static const String genresTable = "genres";
  static const String publishersTable = "publishers";
  static const String locationsTable = "locations";
  static const String bookAuthorRelTable = "book_author_rel";
  static const String bookGenreRelTable = "book_genre_rel";

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  Future<void> openDB() async {
    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    _db = await openDatabase(
      "${await getDatabasesPath()}/shelfless.db",
      version: 1,
      onCreate: (Database db, int version) async {
        // Perform upgrades from version 1 to the current version.
        for (int v = 1; v <= version; v++) {
          upgradeDb(db, v);
        }
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) {
        // Perform upgrades from oldVersion to newVersion.
        for (int v = oldVersion + 1; v <= newVersion; v++) {
          upgradeDb(db, v);
        }
      },
      onDowngrade: (Database db, int oldVersion, int newVersion) {
        // TODO Handle version downgrade.
      },
    );
  }

  /// Redirects to the correct version upgrade to perform.
  static Future<void> upgradeDb(Database db, int targetVersion) async {
    switch (targetVersion) {
      case 1:
        await upgradeVersion1(db);
        break;
      default:
        break;
    }
  }

  /// Performs database definition for version 1.
  static Future<void> upgradeVersion1(Database db) async {
    // Libraries table.
    await db.execute(
      """
      CREATE TABLE $librariesTable(
        ${librariesTable}_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${librariesTable}_name TEXT NOT NULL
      )
      """,
    );

    // Books table.
    await db.execute(
      """
      CREATE TABLE $booksTable(
        ${booksTable}_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${booksTable}_title TEXT NOT NULL,
        ${booksTable}_cover BLOB,
        ${booksTable}_library_id INTEGER,
        ${booksTable}_publish_year INTEGER NOT NULL,
        ${booksTable}_publisher_id INTEGER,
        ${booksTable}_location_id INTEGER,
        ${booksTable}_out INTEGER DEFAULT 0,
        ${booksTable}_edition INTEGER DEFAULT 0,
        ${booksTable}_notes TEXT
      )
      """,
    );

    // Authors table.
    await db.execute(
      """
      CREATE TABLE $authorsTable(
        ${authorsTable}_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${authorsTable}_first_name TEXT NOT NULL,
        ${authorsTable}_last_name TEXT NOT NULL,
        ${authorsTable}_nationality TEXT
      )
      """,
    );

    // Genres table.
    await db.execute(
      """
      CREATE TABLE $genresTable(
        ${genresTable}_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${genresTable}_name TEXT NOT NULL,
        ${genresTable}_color INTEGER DEFAULT 0xFF000000
      )
      """,
    );

    // Publishers table.
    await db.execute(
      """
      CREATE TABLE $publishersTable(
        ${publishersTable}_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${publishersTable}_name TEXT NOT NULL,
        ${publishersTable}_website TEXT
      )
      """,
    );

    // Locations table.
    await db.execute(
      """
      CREATE TABLE $locationsTable(
        ${locationsTable}_id INTEGER PRIMARY KEY AUTOINCREMENT,
        ${locationsTable}_name TEXT NOT NULL
      )
      """,
    );

    // Books to authors relationship table.
    await db.execute(
      """
      CREATE TABLE $bookAuthorRelTable(
        ${bookAuthorRelTable}_book_id INTEGER,
        ${bookAuthorRelTable}_author_id INTEGER,
        PRIMARY KEY (${bookAuthorRelTable}_book_id, ${bookAuthorRelTable}_author_id)
      )
      """,
    );

    // Books to genres relationship table.
    await db.execute(
      """
      CREATE TABLE $bookGenreRelTable(
        ${bookGenreRelTable}_book_id INTEGER,
        ${bookGenreRelTable}_genre_id INTEGER,
        PRIMARY KEY (${bookGenreRelTable}_book_id, ${bookGenreRelTable}_genre_id)
      )
      """,
    );
  }

  // ###############################################################################################################################################################################
  // Helper queries.
  // ###############################################################################################################################################################################

  /// Returns a raw query for selecting all ids of books with the provided filters.
  String filteredBookIds({
    Set<int?>? authorsFilter,
    Set<int?>? genresFilter,
  }) =>
      """
    SELECT DISTINCT ${bookGenreRelTable}_book_id AS ${booksTable}_id
    FROM $bookGenreRelTable JOIN $bookAuthorRelTable
    ON ${bookGenreRelTable}_book_id = ${bookAuthorRelTable}_book_id
    WHERE 1 = 1
    ${authorsFilter != null && authorsFilter.isNotEmpty ? "AND ${bookAuthorRelTable}_author_id IN (${authorsFilter.join(",")})" : ""}
    ${genresFilter != null && genresFilter.isNotEmpty ? "AND ${bookGenreRelTable}_genre_id IN (${genresFilter.join(",")})" : ""}
  """;

  String booksWithAuthorId({
    int? libraryId,
    String? titleFilter,
    Set<int?>? publishersFilter,
  }) =>
      """
    SELECT $booksTable.*, ${bookAuthorRelTable}_author_id
    FROM $booksTable JOIN $bookAuthorRelTable
    ON ${booksTable}_id = ${bookAuthorRelTable}_book_id
    WHERE 1 = 1
    ${libraryId != null ? "AND ${booksTable}_library_id = $libraryId" : ""}
    ${titleFilter != null ? "AND ${booksTable}_title LIKE '%$titleFilter%'" : ""}
    ${publishersFilter != null && publishersFilter.isNotEmpty ? "AND ${booksTable}_publisher_id IN (${publishersFilter.join(",")})" : ""}
    ORDER BY ${booksTable}_id ASC
  """;

  String booksWithGenreId({
    int? libraryId,
    String? titleFilter,
    Set<int?>? publishersFilter,
  }) =>
      """
    SELECT $booksTable.*, ${bookGenreRelTable}_genre_id
    FROM $booksTable JOIN $bookGenreRelTable
    ON ${booksTable}_id = ${bookGenreRelTable}_book_id
    WHERE 1 = 1
    ${libraryId != null ? "AND ${booksTable}_library_id = $libraryId" : ""}
    ${titleFilter != null ? "AND ${booksTable}_title LIKE '%$titleFilter%'" : ""}
    ${publishersFilter != null && publishersFilter.isNotEmpty ? "AND ${booksTable}_publisher_id IN (${publishersFilter.join(",")})" : ""}
    ORDER BY ${booksTable}_id ASC
  """;

  String booksWithAggregateAuthorIds({
    int? libraryId,
    String? titleFilter,
    Set<int?>? publishersFilter,
  }) =>
      """
    SELECT *, GROUP_CONCAT(${bookAuthorRelTable}_author_id) AS author_ids
    FROM (${booksWithAuthorId(
        libraryId: libraryId,
        titleFilter: titleFilter,
      )})
    WHERE 1 = 1
    GROUP BY ${booksTable}_id
  """;

  // ${authorsFilter != null && authorsFilter.isNotEmpty ? "AND author_ids "}

  String booksWithAggregateGenreIds({
    int? libraryId,
    String? titleFilter,
    Set<int?>? publishersFilter,
  }) =>
      """
    SELECT *, GROUP_CONCAT(${bookGenreRelTable}_genre_id) AS genre_ids
    FROM (${booksWithGenreId(
        libraryId: libraryId,
        titleFilter: titleFilter,
      )})
    GROUP BY ${booksTable}_id
  """;

  String books({
    int? libraryId,
    String? titleFilter,
    Set<int?>? publishersFilter,
  }) =>
      """
    SELECT books_with_authors.*, books_with_genres.genre_ids
    FROM (${booksWithAggregateAuthorIds(
        libraryId: libraryId,
        titleFilter: titleFilter,
      )}) AS books_with_authors
    JOIN (${booksWithAggregateGenreIds(
        libraryId: libraryId,
        titleFilter: titleFilter,
      )}) AS books_with_genres
    ON books_with_authors.${booksTable}_id = books_with_genres.${booksTable}_id
    ORDER BY books_with_authors.${booksTable}_id ASC
  """;

  String booksCountByLibraryId() => """
    SELECT ${booksTable}_library_id AS library_id, COUNT(${booksTable}_id) AS books_count
    FROM $booksTable
    GROUP BY ${booksTable}_library_id
  """;

  String libraryGenreIds(int libraryId) => """
    SELECT DISTINCT ${bookGenreRelTable}_genre_id AS genre_id
    FROM $booksTable JOIN $bookGenreRelTable
    ON ${booksTable}_id = ${bookGenreRelTable}_book_id
    WHERE ${booksTable}_library_id = $libraryId
    ORDER BY ${bookGenreRelTable}_genre_id ASC
  """;

  String libraryGenres(int libraryId) => """
    SELECT $genresTable.*
    FROM ${libraryGenreIds(libraryId)} AS genre_ids JOIN $genresTable
    ON genre_ids.genre_id = ${genresTable}_id
    ORDER BY ${genresTable}_id ASC
  """;

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Library CRUDs.
  // ###############################################################################################################################################################################

  Future<RawLibrary?> getRawLibrary(int libraryId) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      librariesTable,
      where: "${librariesTable}_id = ?",
      whereArgs: [libraryId],
      limit: 1,
    );

    return rawData.map((Map<String, dynamic> element) => RawLibrary.fromMap(element)).firstOrNull;
  }

  /// Returns all stored libraries as previews.
  Future<LibraryPreview> getLibrary(int? libraryId) async {
    final List<Map<String, dynamic>> rawData = await _db.rawQuery(
      """
      SELECT $librariesTable.*, bcbli.books_count AS books_count
      FROM $librariesTable LEFT JOIN (${booksCountByLibraryId()}) AS bcbli
      ON ${librariesTable}_id = bcbli.library_id
      WHERE ${librariesTable}_id = $libraryId
      ORDER BY ${librariesTable}_id ASC
      LIMIT 1
      """,
    );

    return rawData.map((Map<String, dynamic> element) => LibraryPreview.fromMap(element)).toList().first;
  }

  /// Returns all stored libraries as previews.
  Future<List<LibraryPreview>> getLibraries() async {
    final List<Map<String, dynamic>> rawData = await _db.rawQuery(
      """
      SELECT $librariesTable.*, bcbli.books_count AS books_count
      FROM $librariesTable LEFT JOIN (${booksCountByLibraryId()}) AS bcbli
      ON ${librariesTable}_id = bcbli.library_id
      ORDER BY ${librariesTable}_id ASC
      """,
    );

    return rawData.map((Map<String, dynamic> element) => LibraryPreview.fromMap(element)).toList();
  }

  /// Inserts the provided library in DB and sets its id with the one provided by the DB itself.
  Future<void> insertRawLibrary(RawLibrary libraryElement) async {
    int id = await _db.insert(librariesTable, libraryElement.toMap());
    libraryElement.id = id;
  }

  Future<void> updateRawLibrary(RawLibrary libraryElement) async {
    await _db.update(
      librariesTable,
      libraryElement.toMap(),
      where: "${librariesTable}_id = ?",
      whereArgs: [libraryElement.id],
    );
  }

  Future<void> deleteRawLibrary(RawLibrary libraryElement) async {
    await _db.delete(
      librariesTable,
      where: "${librariesTable}_id = ?",
      whereArgs: [libraryElement.id],
    );
  }

  /// Extracts all data regarding the library with the provided id.
  Future<Map<String, String>> extractLibrary(int libraryId) async {
    final Map<String, String> result = {};

    // Fetch database info.
    result["db_info"] = jsonEncode({
      "version": await _db.getVersion(),
    });

    // Fetch library info.
    // Only one library is exported, since only one is asked for.
    final List<Map<String, dynamic>> rawLibraries = await _db.query(
      librariesTable,
      where: "${librariesTable}_id = ?",
      whereArgs: [libraryId],
      limit: 1,
    );
    result[librariesTable] = jsonEncode(rawLibraries);

    // Fetch books info.
    // All books in the provided library are exported. All subsequent data depends on the library books.
    final String booksQuery = """
      SELECT *
      FROM $booksTable
      WHERE ${booksTable}_library_id = $libraryId
    """;
    final List<Map<String, dynamic>> rawBooks = await _db.rawQuery(booksQuery);
    result[booksTable] = jsonEncode(rawBooks);

    // Fetch book/genre relationships info.
    final List<Map<String, dynamic>> rawBookGenreRels = await _db.rawQuery("""
      SELECT $bookGenreRelTable.*
      FROM $bookGenreRelTable JOIN $booksTable
      ON ${bookGenreRelTable}_book_id = ${booksTable}_id
      WHERE ${booksTable}_library_id = $libraryId
    """);
    result[bookGenreRelTable] = jsonEncode(rawBookGenreRels);

    // Fetch book/author relationships info.
    final List<Map<String, dynamic>> rawBookAuthorRels = await _db.rawQuery("""
      SELECT $bookAuthorRelTable.*
      FROM $bookAuthorRelTable JOIN $booksTable
      ON ${bookAuthorRelTable}_book_id = ${booksTable}_id
      WHERE ${booksTable}_library_id = $libraryId
    """);
    result[bookAuthorRelTable] = jsonEncode(rawBookAuthorRels);

    // Fetch genres data.
    final List<Map<String, dynamic>> rawGenres = await _db.rawQuery("""
      SELECT $genresTable.*
      FROM $genresTable JOIN (
        SELECT DISTINCT ${bookGenreRelTable}_genre_id
        FROM $bookGenreRelTable JOIN $booksTable
        ON ${bookGenreRelTable}_book_id = ${booksTable}_id
        WHERE ${booksTable}_library_id = $libraryId
      )
      ON ${genresTable}_id = ${bookGenreRelTable}_genre_id
    """);
    result[genresTable] = jsonEncode(rawGenres);

    // Fetch authors data.
    final List<Map<String, dynamic>> rawAuthors = await _db.rawQuery("""
      SELECT $authorsTable.*
      FROM $authorsTable JOIN (
        SELECT DISTINCT ${bookAuthorRelTable}_author_id
        FROM $bookAuthorRelTable JOIN $booksTable
        ON ${bookAuthorRelTable}_book_id = ${booksTable}_id
        WHERE ${booksTable}_library_id = $libraryId
      )
      ON ${authorsTable}_id = ${bookAuthorRelTable}_author_id
    """);
    result[authorsTable] = jsonEncode(rawAuthors);

    // Fetch publishers data.
    final List<Map<String, dynamic>> rawPublishers = await _db.rawQuery("""
      SELECT $publishersTable.*
      FROM $publishersTable JOIN ($booksQuery)
      ON ${publishersTable}_id = ${booksTable}_publisher_id
    """);
    result[publishersTable] = jsonEncode(rawPublishers);

    // Fetch locations data.
    final List<Map<String, dynamic>> rawLocations = await _db.rawQuery("""
      SELECT $locationsTable.*
      FROM $locationsTable JOIN ($booksQuery)
      ON ${locationsTable}_id = ${booksTable}_location_id
    """);
    result[locationsTable] = jsonEncode(rawLocations);

    return result;
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  Future<List<Book>> getLibraryBooks(
    int libraryId, {
    String? titleFilter,
    Set<int?>? authorsFilter,
    Set<int?>? genresFilter,
    Set<int?>? publishersFilter,
  }) async {
    final List<Map<String, dynamic>> rawData = await _db.rawQuery("""
    SELECT all_books.*
    FROM (${books(
      libraryId: libraryId,
      titleFilter: titleFilter,
      publishersFilter: publishersFilter,
    )}) AS all_books
    JOIN (${filteredBookIds(
      authorsFilter: authorsFilter,
      genresFilter: genresFilter,
    )}) AS filtered_books
    ON all_books.${booksTable}_id = filtered_books.${booksTable}_id
    ORDER BY all_books.${booksTable}_id ASC
    """);
    return rawData.map((Map<String, dynamic> element) => Book.fromMap(element)).toList();
  }

  Future<List<RawGenre>> getGenres() async {
    final List<Map<String, dynamic>> rawData = await _db.query(genresTable);
    return rawData.map((Map<String, dynamic> element) => RawGenre.fromMap(element)).toList();
  }

  // ###############################################################################################################################################################################
  // Author CRUDs.
  // ###############################################################################################################################################################################

  /// Returns true if [author] is not referenced in any book.
  Future<bool> isAuthorRogue(Author author) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      bookAuthorRelTable,
      where: "${bookAuthorRelTable}_author_id = ?",
      whereArgs: [author.id],
      limit: 1,
    );

    return rawData.isEmpty;
  }

  Future<List<Author>> getAuthors() async {
    final List<Map<String, dynamic>> rawData = await _db.query(authorsTable);
    return rawData.map((Map<String, dynamic> element) => Author.fromMap(element)).toList();
  }

  Future<RawGenre?> getAuthor(int id) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      authorsTable,
      where: "${authorsTable}_id = ?",
      whereArgs: [id],
    );

    return rawData.isEmpty ? null : RawGenre.fromMap(rawData.first);
  }

  Future<void> insertAuthor(Author author) async {
    // Insert the new author.
    author.id = await _db.insert(authorsTable, author.toMap());
  }

  Future<void> updateAuthor(Author author) async {
    await _db.update(
      authorsTable,
      author.toMap(),
      where: "${authorsTable}_id = ?",
      whereArgs: [author.id],
    );
  }

  Future<void> deleteAuthor(Author author) async {
    await _db.delete(
      authorsTable,
      where: "${authorsTable}_id = ?",
      whereArgs: [author.id],
    );
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Genre CRUDs.
  // ###############################################################################################################################################################################

  /// Returns true if [genre] is not referenced in any book.
  Future<bool> isGenreRogue(RawGenre genre) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      bookGenreRelTable,
      where: "${bookGenreRelTable}_genre_id = ?",
      whereArgs: [genre.id],
      limit: 1,
    );

    return rawData.isEmpty;
  }

  Future<void> insertGenre(RawGenre rawGenre) async {
    // Insert the new genre.
    rawGenre.id = await _db.insert(genresTable, rawGenre.toMap());
  }

  Future<void> updateGenre(RawGenre rawGenre) async {
    await _db.update(
      genresTable,
      rawGenre.toMap(),
      where: "${genresTable}_id = ?",
      whereArgs: [rawGenre.id],
    );
  }

  Future<void> deleteGenre(RawGenre genre) async {
    await _db.delete(
      genresTable,
      where: "${genresTable}_id = ?",
      whereArgs: [genre.id],
    );
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Publisher CRUDs.
  // ###############################################################################################################################################################################

  /// Returns true if [publisher] is not referenced in any book.
  Future<bool> isPublisherRogue(Publisher publisher) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      booksTable,
      where: "${booksTable}_publisher_id = ?",
      whereArgs: [publisher.id],
      limit: 1,
    );

    return rawData.isEmpty;
  }

  Future<List<Publisher>> getPublishers() async {
    final List<Map<String, dynamic>> rawData = await _db.query(publishersTable);
    return rawData.map((Map<String, dynamic> element) => Publisher.fromMap(element)).toList();
  }

  Future<void> insertPublisher(Publisher publisher) async {
    // Insert the new publisher.
    publisher.id = await _db.insert(publishersTable, publisher.toMap());
  }

  Future<void> updatePublisher(Publisher publisher) async {
    await _db.update(
      publishersTable,
      publisher.toMap(),
      where: "${publishersTable}_id = ?",
      whereArgs: [publisher.id],
    );
  }

  Future<void> deletePublisher(Publisher publisher) async {
    await _db.delete(
      publishersTable,
      where: "${publishersTable}_id = ?",
      whereArgs: [publisher.id],
    );
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  // ###############################################################################################################################################################################
  // Location CRUDs.
  // ###############################################################################################################################################################################

  /// Returns true if [location] is not referenced in any book.
  Future<bool> isLocationRogue(StoreLocation location) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      booksTable,
      where: "${booksTable}_location_id = ?",
      whereArgs: [location.id],
      limit: 1,
    );

    return rawData.isEmpty;
  }

  Future<List<StoreLocation>> getLocations() async {
    final List<Map<String, dynamic>> rawData = await _db.query(locationsTable);
    return rawData.map((Map<String, dynamic> element) => StoreLocation.fromMap(element)).toList();
  }

  Future<void> insertLocation(StoreLocation location) async {
    // Insert the new location.
    location.id = await _db.insert(locationsTable, location.toMap());
  }

  Future<void> updateLocation(StoreLocation location) async {
    await _db.update(
      locationsTable,
      location.toMap(),
      where: "${locationsTable}_id = ?",
      whereArgs: [location.id],
    );
  }

  Future<void> deleteLocation(StoreLocation location) async {
    await _db.delete(
      locationsTable,
      where: "${locationsTable}_id = ?",
      whereArgs: [location.id],
    );
  }

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################

  Future<void> insertBook(Book book) async {
    // Insert the new book and update its id.
    book.raw.id = await _db.insert(booksTable, book.raw.toMap());

    // Insert new records in all relationship tables as well.
    for (Map<String, dynamic> authorRelMap in book.authorsMaps()) {
      await _db.insert(bookAuthorRelTable, authorRelMap);
    }
    for (Map<String, dynamic> genreRelMap in book.genresMaps()) {
      await _db.insert(bookGenreRelTable, genreRelMap);
    }
  }

  Future<void> updateBook(Book book) async {
    // Update the book.
    await _db.update(
      booksTable,
      book.raw.toMap(),
      where: "${booksTable}_id = ?",
      whereArgs: [book.raw.id],
    );

    // Delete all deleted relations.
    await _db.delete(
      bookAuthorRelTable,
      where: "${bookAuthorRelTable}_book_id = ? AND ${bookAuthorRelTable}_author_id NOT IN (?)",
      whereArgs: [
        book.raw.id,
        book.authorIds.map((int authorId) => "$authorId").reduce((String value, String element) => "$value, $element"),
      ],
    );
    await _db.delete(
      bookGenreRelTable,
      where: "${bookGenreRelTable}_book_id = ? AND ${bookGenreRelTable}_genre_id NOT IN (?)",
      whereArgs: [
        book.raw.id,
        book.genreIds.map((int genreId) => "$genreId").reduce((String value, String element) => "$value, $element"),
      ],
    );

    // Insert new records in all relationship tables.
    for (Map<String, dynamic> authorRelMap in book.authorsMaps()) {
      await _db.insert(
        bookAuthorRelTable,
        authorRelMap,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    for (Map<String, dynamic> genreRelMap in book.genresMaps()) {
      await _db.insert(
        bookGenreRelTable,
        genreRelMap,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<void> moveBookTo(Book book, RawLibrary library) async {
    await _db.update(
      booksTable,
      book.raw.toMap(),
      where: "${booksTable}_id = ?",
      whereArgs: [book.raw.id],
    );
  }

  Future<void> deleteBook(Book book) async {
    // Delete the book.
    await _db.delete(
      booksTable,
      where: "${booksTable}_id = ?",
      whereArgs: [book.raw.id],
    );

    // Delete all related data.
    await _db.delete(
      bookAuthorRelTable,
      where: "${bookAuthorRelTable}_book_id = ?",
      whereArgs: [book.raw.id],
    );

    await _db.delete(
      bookGenreRelTable,
      where: "${bookGenreRelTable}_book_id = ?",
      whereArgs: [book.raw.id],
    );
  }

  Future<void> addAuthorToBook(int bookId, int authorId) async {
    await _db.insert(
      bookAuthorRelTable,
      {
        "${bookAuthorRelTable}_book_id": bookId,
        "${bookAuthorRelTable}_author_id": authorId,
      },
    );
  }
}
