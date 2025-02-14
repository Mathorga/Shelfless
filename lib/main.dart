import 'package:flutter/material.dart';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/screens/library_content_screen.dart';
import 'package:shelfless/screens/loading_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';

void main() async {
  await DatabaseHelper.instance.openDB();

  // Fetch libraries from DB.
  await LibrariesProvider.instance.fetchLibraries();

  runApp(const Shelfless());
}

class Shelfless extends StatelessWidget {
  const Shelfless({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Themes.appName,
      theme: Themes.shelflessTheme,
      home: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
        LibrariesProvider.instance.addListener(() {
          if (context.mounted) {
            setState(() {});
          }
        });

        return LibrariesProvider.instance.libraries.isEmpty
            // TODO Show an introductory library creation wizard instead of a bare EditLibraryScreen.
            ? EditLibraryScreen()
            : FutureBuilder(
                future: SharedPreferences.getInstance(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  LibraryPreview library = LibrariesProvider.instance.libraries.first;

                  if (snapshot.hasError) {
                    return LibraryContentScreen(
                      library: library,
                    );
                  }

                  if (!snapshot.hasData) {
                    return LoadingScreen();
                  }

                  // Try and read the latest open library from shared preferences.
                  SharedPreferences sharedPrefs = snapshot.data;
                  int? storedLibraryId = sharedPrefs.getInt(SharedPrefsKeys.openLibrary);
                  LibraryPreview? foundLibrary = LibrariesProvider.instance.libraries.firstWhereOrNull((LibraryPreview preview) => preview.raw.id == storedLibraryId);
                  library = foundLibrary ?? library;

                  return LibraryContentScreen(
                    library: library,
                  );
                });
      }),
      routes: {},
    );
  }
}
