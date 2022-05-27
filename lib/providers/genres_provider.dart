import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/genre.dart';

class GenresProvider with ChangeNotifier {
  final Box<Genre> _genres = Hive.box<Genre>("genres");
}