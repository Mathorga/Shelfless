import 'package:flutter/widgets.dart';

import 'package:collection/collection.dart';
import 'package:sqflite/sqflite.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library.dart';
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

  static const String librariesTable = "libraries";
  static const String booksTable = "books";
  static const String authorsTable = "authors";
  static const String genresTable = "genres";
  static const String publishersTable = "publishers";
  static const String locationsTable = "locations";
  static const String bookAuthorRelTable = "book_author_rel";
  static const String bookGenreRelTable = "book_genre_rel";

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
        ${booksTable}_library_id INTEGER,
        ${booksTable}_publish_year INTEGER NOT NULL,
        ${booksTable}_publisher_id INTEGER,
        ${booksTable}_location_id INTEGER,
        ${booksTable}_borrowed BOOL,
        ${booksTable}_edition INTEGER DEFAULT 0
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

  String get booksWithAuthorId => """
  SELECT $booksTable.*, ${bookAuthorRelTable}_author_id
  FROM $booksTable JOIN $bookAuthorRelTable
  ON ${booksTable}_id = ${bookAuthorRelTable}_book_id
  ORDER BY ${booksTable}_id ASC
  """;

  String get booksWithGenreId => """
  SELECT $booksTable.*, ${bookGenreRelTable}_genre_id
  FROM $booksTable JOIN $bookGenreRelTable
  ON ${booksTable}_id = ${bookGenreRelTable}_book_id
  ORDER BY ${booksTable}_id ASC
  """;

  String get booksWithAggregateAuthorIds => """
  SELECT *, GROUP_CONCAT(${bookAuthorRelTable}_author_id) AS author_ids
  FROM ($booksWithAuthorId)
  GROUP BY ${booksTable}_id
  """;

  String get booksWithAggregateGenreIds => """
  SELECT *, GROUP_CONCAT(${bookGenreRelTable}_genre_id) AS genre_ids
  FROM ($booksWithGenreId)
  GROUP BY ${booksTable}_id
  """;

  String get books => """
  SELECT books_with_authors.*, books_with_genres.genre_ids
  FROM ($booksWithAggregateAuthorIds) AS books_with_authors
  JOIN ($booksWithAggregateGenreIds) AS books_with_genres
  ON books_with_authors.${booksTable}_id = books_with_genres.${booksTable}_id
  ORDER BY books_with_authors.${booksTable}_id ASC
  """;

  String get booksCountByLibraryId => """
  SELECT ${booksTable}_library_id AS library_id, COUNT(${booksTable}_id) AS books_count
  FROM $booksTable
  GROUP BY ${booksTable}_library_id
  """;

  /// Returns all stored libraries as previews.
  Future<List<LibraryPreview>> getLibraries() async {
    final List<Map<String, dynamic>> rawData = await _db.rawQuery(
      """
      SELECT $librariesTable.*, bcbli.books_count AS books_count
      FROM $librariesTable LEFT JOIN ($booksCountByLibraryId) AS bcbli
      ON ${librariesTable}_id = bcbli.library_id
      ORDER BY ${librariesTable}_id ASC
      """,
    );

    return rawData.map((Map<String, dynamic> element) => LibraryPreview.fromMap(element)).toList();
  }

  Future<Library> getLibrary(int libraryId) async {
    final List<Book> books = await getLibraryBooks(libraryId);

    final List<Map<String, dynamic>> rawData = await _db.rawQuery("""
      SELECT *
      FROM $librariesTable
      WHERE ${librariesTable}_id = $libraryId
      ORDER BY ${librariesTable}_id
      LIMIT 1
      """);

    return Library(
      id: libraryId,
      name: rawData.firstOrNull?["${librariesTable}_name"],
      books: books,
    );
  }

  Future<RawLibrary?> getRawLibrary(int libraryId) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      librariesTable,
      where: "${librariesTable}_id = ?",
      whereArgs: [libraryId],
      limit: 1,
    );

    return rawData.map((Map<String, dynamic> element) => RawLibrary.fromMap(element)).firstOrNull;
  }

  Future<List<Book>> getLibraryBooks(int libraryId) async {
    final List<Map<String, dynamic>> rawData = await _db.rawQuery(books);
    return rawData.map((Map<String, dynamic> element) => Book.fromMap(map: element)).toList();
  }

  Future<void> insertBook(Book book) async {
    // Insert the new book.
    await _db.insert(booksTable, book.raw.toMap());

    // Insert new records in all relationship tables as well.
    for (Map<String, dynamic> authorRelMap in book.authorsMaps()) {
      await _db.insert(bookAuthorRelTable, authorRelMap);
    }
    for (Map<String, dynamic> genreRelMap in book.genresMaps()) {
      await _db.insert(bookGenreRelTable, genreRelMap);
    }
  }

  Future<void> insertLibrary(Library library) async {
    int id = await _db.insert(librariesTable, library.toMap());
    library.id = id;
  }

  /// Inserts the provided library in DB and sets its id with the one provided by the DB itself.
  Future<void> insertRawLibrary(RawLibrary libraryElement) async {
    int id = await _db.insert(librariesTable, libraryElement.toMap());
    libraryElement.id = id;
  }

  Future<void> updateLibrary(Library library) async {
    await _db.update(librariesTable, library.toMap());
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

  Future<Author?> getAuthor(int id) async {
    final List<Map<String, dynamic>> rawData = await _db.query(
      authorsTable,
      where: "${authorsTable}_id = ?",
      whereArgs: [id],
    );

    return rawData.isEmpty ? null : Author.fromMap(rawData.first);
  }
}
