import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shelfless/dialogs/error_dialog.dart';
import 'package:shelfless/dialogs/loading_dialog.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/strings/strings.dart';
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
                    strings.welcomeHeader,
                    style: TextStyle(fontSize: Themes.fontSizeXLarge),
                  ),

                  AppNameWidget(
                    textStyle: TextStyle(
                      fontSize: Themes.fontSizeXXXLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Welcome message.
                  Text(
                    strings.welcomeSubtitle,
                    style: TextStyle(fontSize: Themes.fontSizeMedium),
                  ),
                  Text(
                    strings.welcomeSuggestion,
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
                  // Prefetch handlers before async gaps.
                  final NavigatorState navigator = Navigator.of(context);

                  final Map<String, String>? libraryStrings;

                  // Show loading indicator.
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    // TODO Move to strings!
                    builder: (BuildContext context) => LoadingDialog(title: "Loading library"),
                  );

                  try {
                    libraryStrings = await Utils.pickLibrary();

                    // Only check for database version if outdated libraries are not allowed.
                    if (!Config.allowOutdatedLibraries) {
                      if (!(await DatabaseHelper.instance.validateDbInfo(jsonDecode(libraryStrings["db_info"]!)))) {
                        // Let the user know the provided file is incompatible with the current app version.
                        if (context.mounted) {
                          ErrorDialog(
                            message: strings.incompatibleLibraryVersionErrorContent,
                          ).show(context);
                        }

                        return;
                      }
                    }

                    // Store read library to DB.
                    await DatabaseHelper.instance.storeLibrary(libraryStrings);

                    // Refetch libraries.
                    await LibrariesProvider.instance.fetchLibraries();
                  } catch (e) {
                    // Let the user know something went wrong.
                    if (context.mounted) await showUnexpectedErrorDialog(context);

                    return;
                  } finally {
                    // Pop overlay dialog.
                    navigator.pop();
                  }
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
                      strings.welcomeActionCreate,
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
                      strings.welcomeActionImport,
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
