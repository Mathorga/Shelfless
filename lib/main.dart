import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:collection/collection.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/screens/library_content_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';

void main() async {
  // Open the local database.
  await DatabaseHelper.instance.openDB();

  // Fetch shared preferences.
  await SharedPrefsHelper.instance.init();

  // Fetch libraries from DB.
  await LibrariesProvider.instance.fetchLibraries();

  // Disable runtime fetchin google fonts, since used fonts are already in assets.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Limit orientation to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const Shelfless());
}

class Shelfless extends StatelessWidget {
  const Shelfless({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Themes.appName,
      theme: Themes.shelflessTheme,
      home: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          LibrariesProvider.instance.addListener(() {
            if (context.mounted) {
              setState(() {});
            }
          });

          // TODO Show an introductory library creation wizard instead of a bare EditLibraryScreen.
          if (LibrariesProvider.instance.libraries.isEmpty) return EditLibraryScreen();

          // Try and read the latest open library from shared preferences.
          LibraryPreview library = LibrariesProvider.instance.libraries.first;
          int? storedLibraryId = SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.openLibrary);
          LibraryPreview? foundLibrary = LibrariesProvider.instance.libraries.firstWhereOrNull((LibraryPreview preview) => preview.raw.id == storedLibraryId);
          library = foundLibrary ?? library;

          return LibraryContentScreen(
            library: library,
          );
        },
      ),
      routes: {},
    );
  }
}
