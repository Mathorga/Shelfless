import 'dart:io';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/publisher.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/utils/strings/strings.dart';

part 'library.g.dart';

@HiveType(typeId: 5)
class Library extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  HiveList<Book> books;

  Library({
    required this.name,
    required this.books,
  });

  Library.fromSerializableString({required this.name, required String csvString}) : books = HiveList(Hive.box<Book>("books")) {
    final Box<Book> _books = Hive.box<Book>("books");
    final Box<Author> _authors = Hive.box<Author>("authors");
    final Box<Genre> _genres = Hive.box<Genre>("genres");
    final Box<Publisher> _publishers = Hive.box<Publisher>("publishers");
    final Box<StoreLocation> _locations = Hive.box<StoreLocation>("store_locations");

    // Separate csv lines: each line is a book.
    final List<String> lines = csvString.split("\n");

    // The first line is skipped, as it's just a header.
    for (String bookString in lines.skip(1)) {
      // Prepare book for insertion.
      final Book book = Book(authors: HiveList(_authors), genres: HiveList(_genres));

      // Separate book fields.
      final List<String> fields = bookString.split(";");

      // Populate book fields.
      book.title = fields[0];
      book.publishDate = int.parse(fields[2]);
      book.borrowed = fields.length > 7 ? fields[6] == "true" : false;
      book.edition = fields.length > 8 ? int.parse(fields[7]) : 1;

      // Split authors string into its composing authors.
      final List<String> authorStrings = fields[1].split(" ");

      // Get authors, create them if not already present.
      for (String authorString in authorStrings) {
        // Create a temporary author from the given string.
        final Author author = Author.fromSerializableString(authorString);

        // Make sure the author is already present in the DB, insert it otherwise.
        Author bookAuthor = author;
        if (!_authors.values.contains(author)) {
          _authors.add(author);
          author.save();
        } else {
          bookAuthor = _authors.values.singleWhere((Author element) => element == author);
        }

        book.authors.add(bookAuthor);
      }

      // Split genres string into its composing genres.
      final List<String> genreStrings = fields[3].split(" ");

      // Get genres, create them if not already present.
      for (String genreString in genreStrings) {
        // Create a temporary genre from the given string.
        final Genre genre = Genre.fromSerializableString(genreString);

        // Make sure the genre is already present in the DB, insert it otherwise.
        Genre bookGenre = genre;
        if (!_genres.values.contains(genre)) {
          _genres.add(genre);
          genre.save();
        } else {
          bookGenre = _genres.values.singleWhere((Genre element) => element == genre);
        }

        book.genres.add(bookGenre);
      }

      // Get the publisher, create it if not already present.
      // Create a temporary publisher from the given string.
      final Publisher publisher = Publisher.fromSerializableString(fields[4]);

      // Make sure the publisher is already present in the DB, insert it otherwise.
      Publisher bookPublisher = publisher;
      if (!_publishers.values.contains(publisher)) {
        _publishers.add(publisher);
        publisher.save();
      } else {
        bookPublisher = _publishers.values.singleWhere((Publisher element) => element == publisher);
      }

      book.publisher = bookPublisher;

      // Get store location, create it if not already present.
      // Create a temporary location from the given string.
      final StoreLocation location = StoreLocation(name: fields[5]);

      // Make sure the location is already present in the DB, insert it otherwise.
      StoreLocation bookLocation = location;
      if (!_locations.values.contains(location)) {
        _locations.add(location);
        location.save();
      } else {
        bookLocation = _locations.values.singleWhere((StoreLocation element) => element == location);
      }

      book.location = bookLocation;

      // Save the book to the DB.
      _books.add(book);
      book.save();

      // Add the book to the library.
      books.add(book);
    }
  }

  List<Map<String, String>> get bookMaps {
    return books.map((Book book) => book.toMap()).toList();
  }

  void merge(Library other) {
    // TODO.
  }

  String toSerializableString() {
    const String header = "title;authors;publishDate;genres;publisher;location;borrowed;edition";

    return bookMaps.map<String>((Map<String, String> bookMap) {
      return bookMap.values.reduce((String value, String element) {
        // Concat multiple fields.
        return "$value;$element";
      });
    }).fold(header, (String value, String element) {
      // Concat multiple lines.
      return "$value\n$element";
    });
  }

  @override
  String toString() {
    final int booksLength = books.toList().length;
    return "$name ($booksLength ${booksLength == 1 ? strings.books : strings.books})";
  }

  void writeToFile(String filePath) async {
    // Open a new text file using the library name.
    final File libraryFile = await File(filePath).create(recursive: true);

    // Write the file.
    // No need to await for this one, as it's the last operation.
    libraryFile.writeAsString(toSerializableString());
  }
}
