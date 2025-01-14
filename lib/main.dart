import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shelfless/screens/libraries_overview_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';

void main() async {
  await DatabaseHelper.instance.openDB();
  // SystemChrome.setEnabledSystemUIMode(
  //   SystemUiMode.immersiveSticky,
  // );
  runApp(const Shelfless());
}

class Shelfless extends StatelessWidget {
  const Shelfless({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shelfless",
      theme: ThemeData(
        scaffoldBackgroundColor: ShelflessColors.mainBackground,
        colorScheme: ColorScheme.dark(
          primary: ShelflessColors.primary,
          secondary: ShelflessColors.secondary,
          surface: ShelflessColors.mainBackground,
        ),
        appBarTheme: const AppBarTheme(
          color: ShelflessColors.mainBackground,
          elevation: 0.0,
          scrolledUnderElevation: 0.0,
          centerTitle: true,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStatePropertyAll(ShelflessColors.lightBackground),
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
        // PublisherInfoScreen.routeName: (BuildContext context) => const PublisherInfoScreen(),
        // ImportLibraryScreen.routeName: (BuildContext context) => const ImportLibraryScreen(),
        // BooksFilterScreen.routeName: (BuildContext context) => const BooksFilterScreen(),
      },
    );
  }
}
