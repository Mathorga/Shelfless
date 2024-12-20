import 'package:flutter/foundation.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/utils/database_helper.dart';

class Book {
  int? id;

  String title;

  int libraryId;

  int publishDate;

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
    this.publishDate = 0,
    this.publisherId,
    this.locationId,
    this.borrowed = false,
    this.edition = 1,
    this.authorIds = const [],
    this.genreIds = const [],
  });

  // Book.fromMap({required Map<String, dynamic> map}) : title = map["title"], authors;

  /// Creates and returns a copy of [this].
  Book copy() {
    return Book(
      title: title,
      libraryId: libraryId,
      publishDate: publishDate,
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
    publishDate = other.publishDate;
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
      "${DatabaseHelper.booksTable}_publish_date": publishDate,
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
      other.publishDate == publishDate &&
      other.publisherId == publisherId &&
      other.locationId == locationId &&
      other.borrowed == borrowed &&
      other.edition == edition &&
      listEquals(other.authorIds, authorIds) &&
      listEquals(other.genreIds, genreIds);

  @override
  int get hashCode =>
      title.hashCode +
      publishDate.hashCode +
      publisherId.hashCode +
      locationId.hashCode +
      borrowed.hashCode +
      edition.hashCode +
      Object.hashAll(authorIds) +
      Object.hashAll(genreIds);
}
