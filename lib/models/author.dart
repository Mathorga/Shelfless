import 'package:hive/hive.dart';

part 'author.g.dart';

@HiveType(typeId: 1)
class Author {
  @HiveField(0)
  final String _firstName;

  @HiveField(1)
  final String _lastName;

  Author(
    this._firstName,
    this._lastName,
  );

  @override
  String toString() {
    return "$_firstName $_lastName";
  }
}
