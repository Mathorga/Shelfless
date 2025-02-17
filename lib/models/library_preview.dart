import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/utils/strings/strings.dart';

class LibraryPreview {
  RawLibrary raw;

  int booksCount;

  LibraryPreview({
    required this.raw,
    this.booksCount = 0,
  });

  static String booksCountString(int booksCount) => "($booksCount ${booksCount == 1 ? strings.book : strings.books})";

  LibraryPreview.fromMap(Map<String, dynamic> map)
      : raw = RawLibrary.fromMap(map),
        booksCount = map["books_count"] ?? 0;

  Map<String, dynamic> toElementMap() => raw.toMap();

  @override
  String toString() {
    return "${raw.name} ${LibraryPreview.booksCountString(booksCount)}";
  }
}
