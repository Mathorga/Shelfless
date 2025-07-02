import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/utils.dart';
import 'package:shelfless/widgets/app_name_widget.dart';
import 'package:shelfless/widgets/double_choice_widget.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: Themes.spacingXXLarge,
          children: [
            // Welcome title.
            Padding(
              padding: const EdgeInsets.all(Themes.spacingMedium),
              child: Column(
                spacing: Themes.spacingMedium,
                children: [
                  Text(
                    // TODO Move to strings.
                    "Welcome to",
                    style: TextStyle(fontSize: Themes.fontSizeXLarge),
                  ),

                  AppNameWidget(
                    textStyle: TextStyle(
                      fontSize: Themes.fontSizeXXXLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Welcome message.
                  // TODO Move to strings.
                  Text(
                    "Your personal library catalogue",
                    style: TextStyle(fontSize: Themes.fontSizeMedium),
                  ),
                  Text(
                    // TODO Move to strings.
                    "Start by creating a new library or importing an existing one from file",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Options.
            Padding(
              padding: const EdgeInsets.all(Themes.spacingXXLarge),
              child: DoubleChoiceWidget(
                optionsHeight: Themes.thumbnailSizeMedium,
                onFirstOptionSelected: () {
                  final NavigatorState navigator = Navigator.of(context);

                  // Navigate to edit library screen.
                  navigator.push(MaterialPageRoute(
                    builder: (BuildContext context) => EditLibraryScreen(
                      onDone: () => navigator.pop(),
                    ),
                  ));
                },
                onSecondOptionSelected: () async {
                  final Map<String, String>? libraryStrings;

                  try {
                    libraryStrings = await Utils.deserializeLibrary();

                    if (!(await DatabaseHelper.instance.validateDbInfo(jsonDecode(libraryStrings["db_info"]!)))) {
                      // TODO Let the user know the provided file is incompatible with the current app version.
                      return;
                    }

                    // Store read library to DB.
                    await DatabaseHelper.instance.deserializeLibrary(libraryStrings);

                    // Refetch libraries.
                    LibrariesProvider.instance.fetchLibraries();
                  } catch (e) {
                    // TODO Let the user know.
                    return;
                  }

                  // Pop dialog.
                  // navigator.pop();
                },
                firstOption: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: Themes.spacingSmall,
                  children: [
                    Icon(
                      Icons.playlist_add_rounded,
                      size: Themes.iconSizeLarge,
                    ),
                    Text(
                      // TODO Move to strings.
                      "Create a new library",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                secondOption: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: Themes.spacingSmall,
                  children: [
                    Icon(
                      Icons.download_rounded,
                      size: Themes.iconSizeLarge,
                    ),
                    Text(
                      // TODO Move to strings.
                      "Import an existing library",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
