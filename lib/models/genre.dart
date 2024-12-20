import 'package:shelfless/utils/utils.dart';

class Genre {
  int? id;

  String name;

  int color;

  Genre({
    this.id,
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

  /// Creates and returns a copy of [this].
  Genre copy() {
    return Genre(
      name: name,
      color: color,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Genre other) {
    name = other.name;
    color = other.color;
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
