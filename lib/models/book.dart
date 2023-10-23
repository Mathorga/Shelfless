import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(1)
  String title;

  @HiveField(2)
  HiveList<Author> authors;

  @HiveField(3)
  int publishDate;

  @HiveField(4)
  HiveList<Genre> genres;

  @HiveField(6)
  Publisher? publisher;

  @HiveField(7)
  StoreLocation? location;

  @HiveField(8)
  bool borrowed;

  @HiveField(9)
  int edition;

  Book({
    this.title = "",
    required this.authors,
    this.publishDate = 0,
    required this.genres,
    this.publisher,
    this.location,
    this.borrowed = false,
    this.edition = 1,
  });

  /// Creates and returns a copy of [this].
  Book copy() {
    final Box<Author> _authors = Hive.box<Author>("authors");
    final Box<Genre> _genres = Hive.box<Genre>("genres");

    return Book(
      title: title,
      authors: HiveList(_authors)..addAll(authors),
      publishDate: publishDate,
      genres: HiveList(_genres)..addAll(genres),
      publisher: publisher,
      location: location,
      borrowed: borrowed,
      edition: edition,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Book other) {
    title = other.title;
    authors = other.authors;
    publishDate = other.publishDate;
    genres = other.genres;
    publisher = other.publisher;
    location = other.location;
    borrowed = other.borrowed;
    edition = other.edition;
  }

  Map<String, String> toMap() {
    return {
      "title": title,
      "authors": authors.map((Author author) => author.toSerializableString()).reduce((String value, String element) => "$value $element"),
      "publishDate": publishDate.toString(),
      "genres": genres.map((Genre genre) => genre.toSerializableString()).reduce((String value, String element) => "$value $element"),
      "publisher": publisher != null ? publisher!.toSerializableString() : "",
      "location": location != null ? location!.toSerializableString() : "",
      "borrowed": borrowed.toString(),
      "edition": edition.toString(),
    };
  }

  @override
  bool operator ==(Object other) =>
      other is Book &&
      other.runtimeType == runtimeType &&
      other.title == title &&
      other.publishDate == publishDate &&
      other.publisher == publisher &&
      other.location == location &&
      other.borrowed == borrowed &&
      other.edition == edition &&
      listEquals(other.authors, authors) &&
      listEquals(other.genres, genres);

  @override
  int get hashCode =>
      title.hashCode + publishDate.hashCode + publisher.hashCode + location.hashCode + borrowed.hashCode + edition.hashCode + Object.hashAll(authors) + Object.hashAll(genres);
}
