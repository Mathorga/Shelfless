import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/book.dart';

class BooksProvider with ChangeNotifier {
  final Box<Book> _books = Hive.box<Book>("books");
}