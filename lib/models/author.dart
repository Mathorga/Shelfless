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
    firstName = parts[0];
    lastName = parts[1];
    nationality = parts[2];
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
