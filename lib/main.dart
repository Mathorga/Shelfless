import 'package:flutter/material.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';

import 'package:shelfless/screens/library_content_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';

void main() async {
  await DatabaseHelper.instance.openDB();
  await LibrariesProvider.instance.fetchLibraries();
  runApp(const Shelfless());
}

class Shelfless extends StatelessWidget {
  const Shelfless({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Themes.appName,
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
        dividerTheme: DividerThemeData(
          color: ShelflessColors.onMainBackgroundInactive,
          indent: Themes.spacingLarge,
          endIndent: Themes.spacingLarge,
          thickness: Themes.spacingXXSmall,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: WidgetStatePropertyAll(ShelflessColors.lightBackground),
        ),
        cardTheme: CardTheme(
          color: ShelflessColors.lightBackground,
          clipBehavior: Clip.antiAlias,
          surfaceTintColor: ShelflessColors.lightBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Themes.radiusMedium),
          ),
          elevation: 6.0,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: ShelflessColors.mainContentInactive,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Themes.radiusSmall),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: ShelflessColors.mainContentInactive,
          contentTextStyle: TextStyle(color: ShelflessColors.onMainContentActive),
          closeIconColor: ShelflessColors.onMainContentActive,
          actionBackgroundColor: ShelflessColors.onMainContentInactive,
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Themes.radiusSmall),
          ),
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
      home: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) setState) {
          LibrariesProvider.instance.addListener(() => setState(() {}));

          return LibrariesProvider.instance.libraries.isEmpty
              ? EditLibraryScreen()
              : LibraryContentScreen(
                  library: LibrariesProvider.instance.libraries.first,
                );
        }
      ),
      routes: {},
    );
  }
}
