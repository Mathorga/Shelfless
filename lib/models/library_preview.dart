import 'package:shelfless/models/library_element.dart';
import 'package:shelfless/utils/strings/strings.dart';

class LibraryPreview {
  LibraryElement libraryElement;

  int booksCount;

  LibraryPreview({
    required this.libraryElement,
    this.booksCount = 0,
  });

  LibraryPreview.fromMap(Map<String, dynamic> map)
      : libraryElement = LibraryElement.fromMap(map),
        booksCount = map["books_count"] ?? 0;

  Map<String, dynamic> toElementMap() => libraryElement.toMap();

  @override
  String toString() {
    return "${libraryElement.name} $booksCount ${booksCount == 1 ? strings.book : strings.books}";
  }
}
