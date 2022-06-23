import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/library.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/providers/store_locations_provider.dart';
import 'package:shelfish/screens/author_info_screen.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/book_info_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/screens/edit_location_screen.dart';
import 'package:shelfish/screens/genre_info_screen.dart';
import 'package:shelfish/screens/libraries_overview_screen.dart';
import 'package:shelfish/screens/locations_overview_screen.dart';
import 'package:shelfish/screens/library_screen.dart';

void main() async {
  // Init local DB.
  await Hive.initFlutter();

  // Register adapters.
  Hive.registerAdapter(BookAdapter());
  Hive.registerAdapter(AuthorAdapter());
  Hive.registerAdapter(GenreAdapter());
  Hive.registerAdapter(StoreLocationAdapter());
  Hive.registerAdapter(LibraryAdapter());

  // Open hive boxes.
  await Hive.openBox<Book>("books");
  await Hive.openBox<Author>("authors");
  await Hive.openBox<Genre>("genres");
  await Hive.openBox<StoreLocation>("store_locations");
  await Hive.openBox<Library>("libraries");

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
        ChangeNotifierProvider(create: (BuildContext contex) => StoreLocationsProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => LibrariesProvider()),
      ],
      child: MaterialApp(
        title: "Shelfish",
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(
            primary: Colors.cyanAccent,
            secondary: Colors.cyanAccent,
          ),

          appBarTheme: const AppBarTheme(
            color: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 0.0),
        ),
        home: const LibrariesOverviewScreen(),
        routes: {
          LibrariesOverviewScreen.routeName: (BuildContext context) => const LibrariesOverviewScreen(),
          LibraryScreen.routeName: (BuildContext context) => const LibraryScreen(),
          BooksScreen.routeName: (BuildContext context) => const BooksScreen(),
          LocationsOverviewScreen.routeName: (BuildContext context) => const LocationsOverviewScreen(),
          BookInfoScreen.routeName: (BuildContext context) => const BookInfoScreen(),
          AuthorInfoScreen.routeName: (BuildContext context) => const AuthorInfoScreen(),
          GenreInfoScreen.routeName: (BuildContext context) => const GenreInfoScreen(),
          EditBookScreen.routeName: (BuildContext context) => const EditBookScreen(),
          EditAuthorScreen.routeName: (BuildContext context) => const EditAuthorScreen(),
          EditGenreScreen.routeName: (BuildContext context) => const EditGenreScreen(),
          EditLocationScreen.routeName: (BuildContext context) => const EditLocationScreen(),
        },
      ),
    );
  }
}
