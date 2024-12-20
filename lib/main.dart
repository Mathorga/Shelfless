import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/providers/authors_provider.dart';
import 'package:shelfless/providers/books_provider.dart';
import 'package:shelfless/providers/genres_provider.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/publishers_provider.dart';
import 'package:shelfless/providers/store_locations_provider.dart';
import 'package:shelfless/screens/books_filter_screen.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/screens/import_library_screen.dart';
import 'package:shelfless/screens/libraries_overview_screen.dart';
import 'package:shelfless/screens/publisher_info_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

void main() async {
  runApp(const Shelfish());
}

class Shelfish extends StatelessWidget {
  const Shelfish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext contex) => BooksProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => GenresProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => AuthorsProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => PublishersProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => StoreLocationsProvider()),
        ChangeNotifierProvider(create: (BuildContext contex) => LibrariesProvider()),
      ],
      child: MaterialApp(
        title: "Shelfless",
        theme: ThemeData(
          scaffoldBackgroundColor: ShelflessColors.mainBackground,
          colorScheme: ColorScheme.dark(
            primary: ShelflessColors.primary,
            secondary: ShelflessColors.secondary,
            background: ShelflessColors.mainBackground,
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
            elevation: 6.0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Themes.radiusMedium),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(Themes.radiusMedium),
            ),
          ),
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Themes.radiusMedium),
            ),
            backgroundColor: ShelflessColors.lightBackground,
          ),
        ),
        home: const LibrariesOverviewScreen(),
        routes: {
          LibrariesOverviewScreen.routeName: (BuildContext context) => const LibrariesOverviewScreen(),
          PublisherInfoScreen.routeName: (BuildContext context) => const PublisherInfoScreen(),
          ImportLibraryScreen.routeName: (BuildContext context) => const ImportLibraryScreen(),
          BooksFilterScreen.routeName: (BuildContext context) => const BooksFilterScreen(),
          EditGenreScreen.routeName: (BuildContext context) => const EditGenreScreen(),
        },
      ),
    );
  }
}
