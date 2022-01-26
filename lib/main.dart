import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/insert_book_screen.dart';
import 'package:shelfish/screens/main_screen.dart';

void main() async {
  // Init local DB.
  await Hive.initFlutter();

  // Register adapters.
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(AuthorAdapter());
  Hive.registerAdapter(GenreAdapter());

  // Open boxes.
  await Hive.openBox<Book>("books");
  await Hive.openBox<Book>("authors");
  await Hive.openBox<Book>("genres");

  runApp(const Shelfish());
}

class Shelfish extends StatelessWidget {
  const Shelfish({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shelfish",
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MainScreen(),
      routes: {
        MainScreen.routeName: (BuildContext context) => const MainScreen(),
        InsertBookScreen.routeName: (BuildContext context) => const InsertBookScreen(),
      },
    );
  }
}
