import 'package:shelfless/utils/database_helper.dart';

class Author {
  int? id;

  String firstName;

  String lastName;

  String nationality;

  Author({
    this.id,
    required this.firstName,
    required this.lastName,
    this.nationality = "",
  });

  Author.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.authorsTable}_id"],
        firstName = map["${DatabaseHelper.authorsTable}_first_name"],
        lastName = map["${DatabaseHelper.authorsTable}_last_name"],
        nationality = map["${DatabaseHelper.authorsTable}_nationality"];

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.authorsTable}_id": id,
      "${DatabaseHelper.authorsTable}_first_name": firstName,
      "${DatabaseHelper.authorsTable}_last_name": lastName,
      "${DatabaseHelper.authorsTable}_nationality": nationality,
    };
  }

  /// Creates and returns a copy of [this].
  Author copy() {
    return Author(
      firstName: firstName,
      lastName: lastName,
      nationality: nationality,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Author other) {
    firstName = other.firstName;
    lastName = other.lastName;
    nationality = other.nationality;
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }

  @override
  bool operator ==(Object other) =>
      other is Author && other.runtimeType == runtimeType && other.firstName == firstName && other.lastName == lastName && other.nationality == nationality;

  @override
  int get hashCode => firstName.hashCode + lastName.hashCode + nationality.hashCode;
}
