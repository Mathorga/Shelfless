import 'package:shelfless/utils/database_helper.dart';

class Publisher {
  int? id;

  String name;

  String? website;

  Publisher({
    this.id,
    required this.name,
    this.website,
  });

  Publisher.fromSerializableString(String source) : name = "" {
    final List<String> parts = source.split("/");
    name = parts[0].replaceAll("_", " ");
    website = parts.length > 1 ? parts[1].isNotEmpty ? parts[1] : null : null;
  }

  Publisher.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.publishersTable}_id"],
        name = map["${DatabaseHelper.publishersTable}_name"],
        website = map["${DatabaseHelper.publishersTable}_website"];

  Map<String, dynamic> toMap() {
    return {
      "${DatabaseHelper.publishersTable}_id": id,
      "${DatabaseHelper.publishersTable}_name": name,
      "${DatabaseHelper.publishersTable}_website": website,
    };
  }

  /// Creates and returns a copy of [this].
  Publisher copy() {
    return Publisher(
      name: name,
      website: website,
    );
  }

  /// Copies all attributes from [other].
  void copyFrom(Publisher other) {
    name = other.name;
    website = other.website;
  }

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
