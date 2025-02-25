import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/database/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/double_choice_dialog.dart';

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

                        // Let the user pick the library file.
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.any,
                        );

                        if (result == null) return;

                        final String? fileName = result.names.single;

                        if (fileName == null) {
                          // TODO Let the user know an error occurred.
                          return;
                        }

                        if (!fileName.endsWith(libraryFileFormat)) {
                          // TODO Let the user know they picked the wrong file type.
                          return;
                        }

                        File file = File(result.files.single.path!);
                        final Uint8List fileData = file.readAsBytesSync();

                        // Decompress the library file.
                        final Archive archive = ZipDecoder().decodeBytes(fileData);

                        final Map<String, String> libraryStrings = Map.fromEntries(archive.map((ArchiveFile archiveFile) {
                          // final File entryFile = File(archiveFile.);
                          String fileName = archiveFile.name.split(".").first;
                          String fileContent = String.fromCharCodes(archiveFile.readBytes()!.toList());
                          return MapEntry(fileName, fileContent);
                        }));

                        // Make sure the provided data contains db info.
                        if (!libraryStrings.containsKey("db_info")) {
                          // TODO Let the user know the provided file is invalid.
                          return;
                        }

                        if (!(await DatabaseHelper.instance.validateDbInfo(jsonDecode(libraryStrings["db_info"]!)))) {
                          // TODO Let the user know the provided file is incompatible with the current app version.
                          return;
                        }

                        // Store read library to DB.
                        await DatabaseHelper.instance.deserializeLibrary(libraryStrings);

                        // Refetch libraries.
                        LibrariesProvider.instance.fetchLibraries();

                        // Pop dialog.
                        navigator.pop();
                      },
                      firstOption: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
