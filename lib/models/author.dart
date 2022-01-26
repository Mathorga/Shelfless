import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
class Author extends HiveObject {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  Author(
    this.firstName,
    this.lastName,
  );

  @override
  String toString() {
    return "$firstName $lastName";
  }
}
