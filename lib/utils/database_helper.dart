import 'package:flutter/widgets.dart';
import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library.dart';

import 'package:sqflite/sqflite.dart';

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
        ${booksTable}_publish_date INTEGER NOT NULL,
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
        ${authorsTable}_id INTEGER PRIMARY KEY AUTOINCREMENT
        ${authorsTable}_first_name TEXT NOT NULL
        ${authorsTable}_last_name TEXT NOT NULL
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
        ${bookAuthorRelTable}_book_id INTEGER PRIMARY KEY,
        ${bookAuthorRelTable}_author_id INTEGER PRIMARY KEY
      )
      """,
    );

    // Books to genres relationship table.
    await db.execute(
      """
      CREATE TABLE $bookGenreRelTable(
        ${bookGenreRelTable}_book_id INTEGER PRIMARY KEY,
        ${bookGenreRelTable}_genre_id INTEGER PRIMARY KEY
      )
      """,
    );
  }

  String get booksWithAuthorId => """
  SELECT $booksTable.*, ${bookAuthorRelTable}_id
  FROM $booksTable JOIN $bookAuthorRelTable
  ON ${booksTable}_id = ${bookAuthorRelTable}_book_id
  ORDER_BY ${booksTable}_id ASC
  """;

  String get booksWithGenreId => """
  SELECT $booksTable.*, ${bookGenreRelTable}_id
  FROM $booksTable JOIN $bookGenreRelTable
  ON ${booksTable}_id = ${bookGenreRelTable}_book_id
  ORDER_BY ${booksTable}_id ASC
  """;

  /// Returns all stored libraries.
  Future<List<Library>?> get libraries async {
    // Fetch all books sorted by library.
    // final List<Map<String, dynamic>> rawData = await _db.query(
    //   "$booksTable JOIN $authorsTable ON $booksTable.authorId = $authorsTable.id",
    //   orderBy: "libraryId, id DESC",
    // );

    // TODO
    final List<Map<String, dynamic>> rawData = await _db.rawQuery(
      """
      SELECT books_with_author_id.*, books_with_genre_id.*
      FROM ($booksWithAuthorId) AS books_with_author_id JOIN ($booksWithGenreId) AS books_with_genre_id
      ON books_with_author_id.${booksTable}_id = books_with_genre_id.${booksTable}_id
      ORDER BY books_with_author_id.${booksTable}_id ASC
      """,
    );

    // final List<Book> books = rawData.map((Map<String, dynamic> element) => Book.fromMap(element)).toList();

    // return rawData.map((Map<String, dynamic> element) => Library.fromMap(element)).toList();
  }

  Future<void> insertBook(Book book) async {
    // Insert the new book.
    await _db.insert(booksTable, book.toMap());

    // Insert new records in all relationship tables as well.
    for (Map<String, dynamic> authorRelMap in book.authorsMaps()) {
      await _db.insert(bookAuthorRelTable, authorRelMap);
    }
    for (Map<String, dynamic> genreRelMap in book.genresMaps()) {
      await _db.insert(bookGenreRelTable, genreRelMap);
    }
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
