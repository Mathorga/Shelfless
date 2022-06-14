import 'package:hive/hive.dart';

part 'genre.g.dart';

@HiveType(typeId: 2)
class Genre extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int color;

  Genre({
    required this.name,
    required this.color,
  });
}