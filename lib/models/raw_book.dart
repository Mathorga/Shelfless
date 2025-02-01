
import 'dart:typed_data';

import 'package:shelfless/utils/database_helper.dart';

class RawBook {
  int? id;

  String title;

  Uint8List? cover;

  int? libraryId;

  int publishYear;

  int? publisherId;

  int? locationId;

  bool out;

  int edition;

  RawBook({
    this.id,
    this.title = "",
    this.cover,
    required this.libraryId,
    this.publishYear = 0,
    this.publisherId,
    this.locationId,
    this.out = false,
    this.edition = 1,
  });

  RawBook.fromMap({required Map<String, dynamic> map})
      : id = map["${DatabaseHelper.booksTable}_id"],
        title = map["${DatabaseHelper.booksTable}_title"],
        cover = map["${DatabaseHelper.booksTable}_cover"],
        libraryId = map["${DatabaseHelper.booksTable}_library_id"],
        publishYear = map["${DatabaseHelper.booksTable}_publish_year"],
        publisherId = map["${DatabaseHelper.booksTable}_publisher_id"],
        locationId = map["${DatabaseHelper.booksTable}_location_id"],
        out = map["${DatabaseHelper.booksTable}_out"] == 1,
        edition = map["${DatabaseHelper.booksTable}_edition"];

  /// Creates and returns a copy of [this].
  RawBook copy() {
    return RawBook(
      id: id,
      title: title,
      cover: cover,
      libraryId: libraryId,
      publishYear: publishYear,
      publisherId: publisherId,
      locationId: locationId,
      out: out,
      edition: edition,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(RawBook other) {
    id = other.id;
    title = other.title;
    cover = other.cover;
    libraryId = other.libraryId;
    publishYear = other.publishYear;
    publisherId = other.publisherId;
    locationId = other.locationId;
    out = other.out;
    edition = other.edition;
  }

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.booksTable}_id": id,
      "${DatabaseHelper.booksTable}_title": title,
      "${DatabaseHelper.booksTable}_cover": cover,
      "${DatabaseHelper.booksTable}_library_id": libraryId,
      "${DatabaseHelper.booksTable}_publish_year": publishYear,
      "${DatabaseHelper.booksTable}_publisher_id": publisherId,
      "${DatabaseHelper.booksTable}_location_id": locationId,
      "${DatabaseHelper.booksTable}_out": out ? 1 : 0,
      "${DatabaseHelper.booksTable}_edition": edition,
    };
  }

  @override
  bool operator ==(Object other) =>
      other is RawBook &&
      other.runtimeType == runtimeType &&
      other.title == title &&
      other.publishYear == publishYear &&
      other.publisherId == publisherId &&
      other.locationId == locationId &&
      other.out == out &&
      other.edition == edition;

  @override
  int get hashCode =>
      title.hashCode +
      publishYear.hashCode +
      publisherId.hashCode +
      locationId.hashCode +
      out.hashCode +
      edition.hashCode;
}