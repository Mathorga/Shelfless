import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/providers/database_provider.dart';

import 'package:shelfish/screens/main_screen.dart';

void main() async {
  // Init local DB.
  await Hive.initFlutter();

  // Register adapters.
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(AuthorAdapter());
  Hive.registerAdapter(GenreAdapter());

  runApp(const Shelfish());
}

class Shelfish extends StatelessWidget {
  const Shelfish({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => DatabaseProvider(),
      child: MaterialApp(
        title: "Shelfish",
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: const MainScreen(),
      ),
    );
  }
}
