import 'package:hive/hive.dart';

part 'publisher.g.dart';

@HiveType(typeId: 3)
class Publisher extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String? website;

  Publisher({
    required this.name,
    this.website,
  });

  @override
  String toString() {
    return name + (website ?? "");
  }

  @override
  bool operator ==(Object other) => other is Publisher && other.runtimeType == runtimeType && other.name == name && other.website == website;

  @override
  int get hashCode => name.hashCode;

  String toSerializableString() {
    return "${name.replaceAll(" ", "_")}/${(website ?? "").replaceAll(" ", "_")}";
  }
}
