import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelfless/dialogs/error_dialog.dart';
import 'package:shelfless/dialogs/loading_dialog.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/utils/utils.dart';
import 'package:shelfless/dialogs/double_choice_dialog.dart';

class LibrariesListWidget extends StatefulWidget {
  const LibrariesListWidget({super.key});

  @override
  State<LibrariesListWidget> createState() => _LibrariesListWidgetState();
}

class _LibrariesListWidgetState extends State<LibrariesListWidget> {
  @override
  void initState() {
    super.initState();

    LibrariesProvider.instance.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    LibrariesProvider.instance.removeListener(_onContentChanged);

    super.dispose();
  }

  void _onContentChanged() {
    if (context.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Libraries list.
        ...List.generate(LibrariesProvider.instance.libraries.length + 2, (int index) {
          // Add library.
          if (index > LibrariesProvider.instance.libraries.length) {
            return _buildLibraryEntry(
              onPressed: () {
                // Show dialog asking the user whether to create a new library or import one.
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DoubleChoiceDialog(
                      title: Text(strings.addLibraryTitle),
                      onFirstOptionSelected: () async {
                        // Prefetch handlers before async gaps.
                        final NavigatorState navigator = Navigator.of(context);

                        // Navigate to library creation screen.
                        await navigator.push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => EditLibraryScreen(
                              onDone: () => navigator.pop(),
                            ),
                          ),
                        );

                        // Pop dialog.
                        navigator.pop();
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

                        // Pop dialog if everything went right.
                        navigator.pop();
                      },
                      firstOption: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: Themes.spacingSmall,
                        children: [
                          Icon(
                            Icons.playlist_add_rounded,
                            size: Themes.iconSizeLarge,
                          ),
                          Text(strings.newLib),
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
                          Text(strings.importLib),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(strings.newLib),
                  Icon(Icons.add_rounded),
                ],
              ),
            );
          }

          // All libraries.
          if (index == LibrariesProvider.instance.libraries.length) {
            return _buildLibraryEntry(
              onPressed: () {
                final NavigatorState navigator = Navigator.of(context);

                // Load the selected library's content.
                LibraryContentProvider.instance.clear();
                LibraryContentProvider.instance.openLibrary();

                navigator.pop();
              },
              highlighted: LibraryContentProvider.instance.library == null,
              child: Row(
                spacing: Themes.spacingSmall,
                children: [
                  if (LibraryContentProvider.instance.library == null)
                    Icon(
                      Icons.double_arrow_rounded,
                      size: Themes.iconSizeSmall,
                    ),
                  Expanded(
                    child: Text(
                      "${strings.all} ${LibraryPreview.booksCountString(LibrariesProvider.instance.totalBooksCount)}",
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (LibraryContentProvider.instance.library == null)
                    Transform.flip(
                      flipX: true,
                      child: Icon(
                        Icons.double_arrow_rounded,
                        size: Themes.iconSizeSmall,
                      ),
                    ),
                ],
              ),
            );
          }

          final LibraryPreview library = LibrariesProvider.instance.libraries[index];
          final bool selectedLibrary = library.raw == LibraryContentProvider.instance.library;

          // Simple library.
          return _buildLibraryEntry(
            onPressed: () async {
              final NavigatorState navigator = Navigator.of(context);

              // Load the selected library's content.
              LibraryContentProvider.instance.clear();
              LibraryContentProvider.instance.openLibrary(rawLibrary: library.raw);

              // Store the selected library id to shared preferences.
              if (library.raw.id != null) (await SharedPreferences.getInstance()).setInt(SharedPrefsKeys.openLibrary, library.raw.id!);

              navigator.pop();
            },
            highlighted: selectedLibrary,
            child: Row(
              spacing: Themes.spacingSmall,
              children: [
                if (selectedLibrary)
                  Icon(
                    Icons.double_arrow_rounded,
                    size: Themes.iconSizeSmall,
                  ),
                Expanded(
                  child: Text(
                    library.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedLibrary)
                  Transform.flip(
                    flipX: true,
                    child: Icon(
                      Icons.double_arrow_rounded,
                      size: Themes.iconSizeSmall,
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLibraryEntry({
    required Widget child,
    void Function()? onPressed,
    bool highlighted = false,
  }) {
    return Card(
      color: highlighted ? ShelflessColors.secondary : null,
      child: InkWell(
        onTap: onPressed,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
