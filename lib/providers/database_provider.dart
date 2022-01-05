import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider extends ChangeNotifier {
  Database? _database;

  DatabaseProvider();

  Database? getDatabase() {
    return _database;
  }

  void openDB() async {
    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized();

    // Open the database and store the reference.
    _database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), "libraries.db"),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          """
          CREATE TABLE book_exemplar(
            id INTEGER PRIMARY KEY,
            book_id INTEGER
          );
          CREATE TABLE book(
            id INTEGER PRIMARY KEY,
            library INTEGER,
            title TEXT,
            publish_date INTEGER,
            genre INTEGER,
            publisher TEXT,
            location TEXT
          );
          CREATE TABLE r_book_author(
            book_id INTEGER,
            author_id INTEGER,
            PRIMARY KEY (book_id, author_id)
          );
          CREATE TABLE author(
            id INTEGER PRIMARY KEY,
            first_name TEXT,
            last_name TEXT
          );
          CREATE TABLE genre(
            id INTEGER PRIMARY KEY,
            name TEXT,
            color INTEGER
          );
          CREATE TABLE library(
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER
          );
          """,
        );
      },
      version: 1,
    );
  }
}
