import 'package:shelfless/utils/database/database_helper.dart';
import 'package:shelfless/utils/utils.dart';

class RawGenre {
  int? id;

  String name;

  int color;

  RawGenre({
    this.id,
    required this.name,
    required this.color,
  });

  RawGenre.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.genresTable}_id"],
        name = map["${DatabaseHelper.genresTable}_name"],
        color = map["${DatabaseHelper.genresTable}_color"];

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.genresTable}_id": id,
      "${DatabaseHelper.genresTable}_name": name,
      "${DatabaseHelper.genresTable}_color": color,
    };
  }

  RawGenre.fromSerializableString(String source)
      : name = "",
        color = 0x00000000 {
    final List<String> parts = source.split("/");
    name = parts[0];
    color = parts.length > 1 ? int.parse(parts[1]) : Utils.randomColor();
  }

  /// Creates and returns a copy of [this].
  RawGenre copy() {
    return RawGenre(
      name: name,
      color: color,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(RawGenre other) {
    name = other.name;
    color = other.color;
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) => other is RawGenre && other.runtimeType == runtimeType && other.name == name;
  
  @override
  int get hashCode => name.hashCode;

  String toSerializableString() {
    return "${name.replaceAll(" ", "_")}/$color";
  }
}
