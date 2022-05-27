import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/screens/authors_overview_screen.dart';
import 'package:shelfish/screens/book_info_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/books_overview_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/screens/genres_overview_screen.dart';

void main() async {
  // Init local DB.
  await Hive.initFlutter();

  // Register adapters.
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(AuthorAdapter());
  Hive.registerAdapter(GenreAdapter());

  // Open boxes.
  await Hive.openBox<Book>("books");
  await Hive.openBox<Author>("authors");
  await Hive.openBox<Genre>("genres");

  runApp(const Shelfish());
}

class Shelfish extends StatelessWidget {
  const Shelfish({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext contex) => BooksProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => GenresProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => AuthorsProvider()),
      ],
      child: MaterialApp(
        title: "Shelfish",
        theme: ThemeData.dark(
            // primarySwatch: Colors.blueGrey,
            ),
        home: const BooksOverviewScreen(),
        routes: {
          BooksOverviewScreen.routeName: (BuildContext context) => const BooksOverviewScreen(),
          GenresOverviewScreen.routeName: (BuildContext context) => const GenresOverviewScreen(),
          AuthorsOverviewScreen.routeName: (BuildContext context) => const AuthorsOverviewScreen(),
          BookInfoScreen.routeName: (BuildContext context) => const BookInfoScreen(),
          EditBookScreen.routeName: (BuildContext context) => const EditBookScreen(),
          EditAuthorScreen.routeName: (BuildContext context) => const EditAuthorScreen(),
          EditGenreScreen.routeName: (BuildContext context) => const EditGenreScreen(),
        },
      ),
    );
  }
}
