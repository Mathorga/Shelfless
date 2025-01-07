import 'package:shelfless/utils/database_helper.dart';

class LibraryElement {
  int? id;

  String name;

  LibraryElement({
    this.id,
    this.name = "",
  });

  LibraryElement.fromMap(Map<String, dynamic> map)
      : id = map["${DatabaseHelper.librariesTable}_id"],
        name = map["${DatabaseHelper.librariesTable}_name"];

  Map<String, dynamic> toMap() => {
        "${DatabaseHelper.librariesTable}_id": id,
        "${DatabaseHelper.librariesTable}_name": name,
      };
}
