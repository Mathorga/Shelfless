import 'package:flutter/foundation.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';

class Book {
  String title;

  List<Author> authors;

  int publishDate;

  List<Genre> genres;

  Publisher? publisher;

  StoreLocation? location;

  bool borrowed;

  int edition;

  Book({
    this.title = "",
    this.authors = const [],
    this.publishDate = 0,
    this.genres = const [],
    this.publisher,
    this.location,
    this.borrowed = false,
    this.edition = 1,
  });

  /// Creates and returns a copy of [this].
  Book copy() {
    return Book(
      title: title,
      authors: [...authors],
      publishDate: publishDate,
      genres: [...genres],
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
