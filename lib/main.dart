import 'package:flutter/material.dart';

import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/screens/library_content_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';

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
            : LibraryContentScreen(
                library: LibrariesProvider.instance.libraries.first,
              );
      }),
      routes: {},
    );
  }
}
