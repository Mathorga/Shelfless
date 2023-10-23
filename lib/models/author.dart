import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
class Author extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String nationality;

  Author({
    required this.firstName,
    required this.lastName,
    this.nationality = "",
  });

  Author.fromSerializableString(String source)
      : firstName = "",
        lastName = "",
        nationality = "" {
    final List<String> parts = source.split("/");

    if (parts.isNotEmpty) {
      firstName = parts[0].replaceAll("_", " ");
    }

    if (parts.length > 1) {
      lastName = parts[1].replaceAll("_", " ");
    }

    if (parts.length > 2) {
      nationality = parts[2].replaceAll("_", " ");
    }
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

  String toSerializableString() {
    return "${firstName.replaceAll(" ", "_")}/${lastName.replaceAll(" ", "_")}/${nationality.replaceAll(" ", "_")}";
  }
}
