import 'package:flutter/foundation.dart';

import 'package:shelfless/models/raw_book.dart';
import 'package:shelfless/utils/database_helper.dart';

class Book {
  RawBook raw;

  List<int> authorIds;

  List<int> genreIds;

  Book({
    required this.raw,
    this.authorIds = const [],
    this.genreIds = const [],
  });

  Book.fromMap(Map<String, dynamic> map)
      : raw = RawBook.fromMap(map: map),
        authorIds = map["author_ids"],
        genreIds = map["genre_ids"];

  /// Creates and returns a copy of [this].
  Book copy() {
    return Book(
      raw: raw.copy(),
      authorIds: authorIds,
      genreIds: genreIds,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Book other) {
    raw = other.raw.copy();
    authorIds = other.authorIds;
    genreIds = other.genreIds;
  }

  Iterable<Map<String, dynamic>> authorsMaps() {
    return authorIds.map((int authorId) => {"${DatabaseHelper.bookAuthorRelTable}_book_id": raw.id, "${DatabaseHelper.bookAuthorRelTable}_author_id": authorId});
  }

  Iterable<Map<String, dynamic>> genresMaps() {
    return genreIds.map((int genreId) => {"${DatabaseHelper.bookGenreRelTable}_book_id": raw.id, "${DatabaseHelper.bookGenreRelTable}_genre_id": genreId});
  }

  @override
  bool operator ==(Object other) =>
      other is Book &&
      other.runtimeType == runtimeType &&
      other.raw == raw &&
      listEquals(other.authorIds, authorIds) &&
      listEquals(other.genreIds, genreIds);

  @override
  int get hashCode =>
      raw.hashCode +
      Object.hashAll(authorIds) +
      Object.hashAll(genreIds);
}
