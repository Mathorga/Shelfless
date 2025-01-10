
import 'package:shelfless/utils/database_helper.dart';

class RawBook {
  int? id;

  String title;

  int? libraryId;

  int publishYear;

  int? publisherId;

  int? locationId;

  bool borrowed;

  int edition;

  RawBook({
    this.id,
    this.title = "",
    required this.libraryId,
    this.publishYear = 0,
    this.publisherId,
    this.locationId,
    this.borrowed = false,
    this.edition = 1,
  });

  RawBook.fromMap({required Map<String, dynamic> map})
      : id = map["${DatabaseHelper.booksTable}_id"],
        title = map["${DatabaseHelper.booksTable}_title"],
        libraryId = map["${DatabaseHelper.booksTable}_library_id"],
        publishYear = map["${DatabaseHelper.booksTable}_publish_year"],
        publisherId = map["${DatabaseHelper.booksTable}_publisher_id"],
        locationId = map["${DatabaseHelper.booksTable}_location_id"],
        borrowed = map["${DatabaseHelper.booksTable}_borrowed"] == 1,
        edition = map["${DatabaseHelper.booksTable}_edition"];

  /// Creates and returns a copy of [this].
  RawBook copy() {
    return RawBook(
      title: title,
      libraryId: libraryId,
      publishYear: publishYear,
      publisherId: publisherId,
      locationId: locationId,
      borrowed: borrowed,
      edition: edition,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(RawBook other) {
    title = other.title;
    libraryId = other.libraryId;
    publishYear = other.publishYear;
    publisherId = other.publisherId;
    locationId = other.locationId;
    borrowed = other.borrowed;
    edition = other.edition;
  }

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.booksTable}_id": id,
      "${DatabaseHelper.booksTable}_title": title,
      "${DatabaseHelper.booksTable}_library_id": libraryId,
      "${DatabaseHelper.booksTable}_publish_year": publishYear,
      "${DatabaseHelper.booksTable}_publisher_id": publisherId,
      "${DatabaseHelper.booksTable}_location_id": locationId,
      "${DatabaseHelper.booksTable}_borrowed": borrowed ? 1 : 0,
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
      other.borrowed == borrowed &&
      other.edition == edition;

  @override
  int get hashCode =>
      title.hashCode +
      publishYear.hashCode +
      publisherId.hashCode +
      locationId.hashCode +
      borrowed.hashCode +
      edition.hashCode;
}