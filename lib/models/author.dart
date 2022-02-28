import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
class Author extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  Author(
    this.firstName,
    this.lastName,
  );

  @override
  String toString() {
    return "$firstName $lastName";
  }
}
