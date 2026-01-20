import 'package:shelfless/utils/database_helper.dart';

class Author {
  int? id;

  String firstName;

  String lastName;

  String homeLand;

  Author({
    this.id,
    required this.firstName,
    required this.lastName,
    this.homeLand = "",
  });

  Author.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.authorsTable}_id"],
        firstName = map["${DatabaseHelper.authorsTable}_first_name"],
        lastName = map["${DatabaseHelper.authorsTable}_last_name"],
        homeLand = map["${DatabaseHelper.authorsTable}_homeland"] ?? "";

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.authorsTable}_id": id,
      "${DatabaseHelper.authorsTable}_first_name": firstName,
      "${DatabaseHelper.authorsTable}_last_name": lastName,
      "${DatabaseHelper.authorsTable}_homeland": homeLand,
    };
  }

  /// Creates and returns a copy of [this].
  Author copy() {
    return Author(
      firstName: firstName,
      lastName: lastName,
      homeLand: homeLand,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Author other) {
    firstName = other.firstName;
    lastName = other.lastName;
    homeLand = other.homeLand;
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }

  @override
  bool operator ==(Object other) =>
      other is Author && other.runtimeType == runtimeType && other.firstName == firstName && other.lastName == lastName && other.homeLand == homeLand;

  @override
  int get hashCode => firstName.hashCode + lastName.hashCode + homeLand.hashCode;
}
