import 'package:hive/hive.dart';
import 'package:shelfless/utils/utils.dart';

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
        color = 0x00000000 {
    final List<String> parts = source.split("/");
    name = parts[0];
    color = parts.length > 1 ? int.parse(parts[1]) : Utils.randomColor();
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) => other is Genre && other.runtimeType == runtimeType && other.name == name;
  
  @override
  int get hashCode => name.hashCode;

  String toSerializableString() {
    return "${name.replaceAll(" ", "_")}/$color";
  }
}
