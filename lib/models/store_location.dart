import 'package:shelfless/utils/database/database_helper.dart';

class StoreLocation {
  int? id;

  String name;

  StoreLocation({
    this.id,
    required this.name,
  });

  StoreLocation.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.locationsTable}_id"],
        name = map["${DatabaseHelper.locationsTable}_name"];

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.locationsTable}_id": id,
      "${DatabaseHelper.locationsTable}_name": name,
    };
  }

  /// Creates and returns a copy of [this].
  StoreLocation copy() {
    return StoreLocation(
      name: name,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(StoreLocation other) {
    name = other.name;
  }

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) => other is StoreLocation && other.runtimeType == runtimeType && other.name == name;

  @override
  int get hashCode => name.hashCode;

  String toSerializableString() {
    return name;
  }
}
