import 'package:flutter/foundation.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/utils/database_helper.dart';

class Book {
  int? id;

  String title;

  int? libraryId;

  int publishYear;

  int? publisherId;

  int? locationId;

  bool borrowed;

  int edition;

  List<int> authorIds;

  List<int> genreIds;

  Book({
    this.id,
    this.title = "",
    required this.libraryId,
    this.publishYear = 0,
    this.publisherId,
    this.locationId,
    this.borrowed = false,
    this.edition = 1,
    this.authorIds = const [],
    this.genreIds = const [],
  });

  Book.fromMap({required Map<String, dynamic> map})
      : id = map["${DatabaseHelper.booksTable}_id"],
        title = map["${DatabaseHelper.booksTable}_title"],
        libraryId = map["${DatabaseHelper.booksTable}_library_id"],
        publishYear = map["${DatabaseHelper.booksTable}_publish_year"],
        publisherId = map["${DatabaseHelper.booksTable}_publisher_id"],
        locationId = map["${DatabaseHelper.booksTable}_location_id"],
        borrowed = map["${DatabaseHelper.booksTable}_borrowed"],
        edition = map["${DatabaseHelper.booksTable}_edition"],
        authorIds = map["author_ids"],
        genreIds = map["genre_ids"];

  /// Creates and returns a copy of [this].
  Book copy() {
    return Book(
      title: title,
      libraryId: libraryId,
      publishYear: publishYear,
      publisherId: publisherId,
      locationId: locationId,
      borrowed: borrowed,
      edition: edition,
      authorIds: authorIds,
      genreIds: genreIds,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Book other) {
    title = other.title;
    libraryId = other.libraryId;
    publishYear = other.publishYear;
    publisherId = other.publisherId;
    locationId = other.locationId;
    borrowed = other.borrowed;
    edition = other.edition;
    authorIds = other.authorIds;
    genreIds = other.genreIds;
  }

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.booksTable}_id": id,
      "${DatabaseHelper.booksTable}_title": title,
      "${DatabaseHelper.booksTable}_librry_id": libraryId,
      "${DatabaseHelper.booksTable}_publish_year": publishYear,
      "${DatabaseHelper.booksTable}_publisher_id": publisherId,
      "${DatabaseHelper.booksTable}_location_id": locationId,
      "${DatabaseHelper.booksTable}_borrowed": borrowed,
      "${DatabaseHelper.booksTable}_edition": edition,
    };
  }

  Iterable<Map<String, dynamic>> authorsMaps() {
    return authorIds.map((int authorId) => {"${DatabaseHelper.bookAuthorRelTable}_book_id": id, "${DatabaseHelper.bookAuthorRelTable}_author_id": authorId});
  }

  Iterable<Map<String, dynamic>> genresMaps() {
    return genreIds.map((int genreId) => {"${DatabaseHelper.bookGenreRelTable}_book_id": id, "${DatabaseHelper.bookGenreRelTable}_genre_id": genreId});
  }

  @override
  bool operator ==(Object other) =>
      other is Book &&
      other.runtimeType == runtimeType &&
      other.title == title &&
      other.publishYear == publishYear &&
      other.publisherId == publisherId &&
      other.locationId == locationId &&
      other.borrowed == borrowed &&
      other.edition == edition &&
      listEquals(other.authorIds, authorIds) &&
      listEquals(other.genreIds, genreIds);

  @override
  int get hashCode =>
      title.hashCode +
      publishYear.hashCode +
      publisherId.hashCode +
      locationId.hashCode +
      borrowed.hashCode +
      edition.hashCode +
      Object.hashAll(authorIds) +
      Object.hashAll(genreIds);
}
