import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/author.dart';

class AuthorsProvider with ChangeNotifier {
  final Box<Author> _authors = Hive.box<Author>("authors");
}