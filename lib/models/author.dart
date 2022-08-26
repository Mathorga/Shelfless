import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
class Author extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  Author({
    required this.firstName,
    required this.lastName,
  });

  Author.fromSerializableString(String source)
      : firstName = "",
        lastName = "" {
    final List<String> parts = source.split("/");
    firstName = parts[0];
    lastName = parts[1];
  }

  @override
  String toString() {
    return "$firstName $lastName";
  }

  @override
  bool operator ==(Object other) => other is Author && other.runtimeType == runtimeType && other.firstName == firstName && other.lastName == lastName;
  
  @override
  int get hashCode => firstName.hashCode + lastName.hashCode;

  String toSerializableString() {
    return "${firstName.replaceAll(" ", "_")}/${lastName.replaceAll(" ", "_")}";
  }
}
