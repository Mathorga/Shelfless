import 'package:hive/hive.dart';

part 'store_location.g.dart';

@HiveType(typeId: 4)
class StoreLocation extends HiveObject {
  @HiveField(0)
  String name;

  StoreLocation({
    required this.name,
  });

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
