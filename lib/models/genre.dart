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

  Genre.fromSerializableString(String source)
      : name = "",
        color = 0 {
    final List<String> parts = source.split("/");
    name = parts[0];
    color = int.parse(parts[1]);
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) => other is Genre && other.runtimeType == runtimeType && other.name == name && other.color == color;
  
  @override
  int get hashCode => name.hashCode + color.hashCode;

  String toSerializableString() {
    return "${name.replaceAll(" ", "_")}/$color";
  }
}
