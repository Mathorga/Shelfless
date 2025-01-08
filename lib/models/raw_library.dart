import 'package:shelfless/utils/database_helper.dart';

class RawLibrary {
  int? id;

  String name;

  RawLibrary({
    this.id,
    this.name = "",
  });

  RawLibrary.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.librariesTable}_id"],
        name = map["${DatabaseHelper.librariesTable}_name"];

  Map<String, dynamic> toMap() => {
        "${DatabaseHelper.librariesTable}_id": id,
        "${DatabaseHelper.librariesTable}_name": name,
      };
}
