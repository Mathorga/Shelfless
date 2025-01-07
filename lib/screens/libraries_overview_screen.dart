import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:shelfless/models/library.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/screens/library_screen.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/library_preview_widget.dart';

class LibrariesOverviewScreen extends StatefulWidget {
  static const String routeName = "/libraries_overview";

  const LibrariesOverviewScreen({Key? key}) : super(key: key);

  @override
  State<LibrariesOverviewScreen> createState() => _LibrariesOverviewScreenState();
}

class _LibrariesOverviewScreenState extends State<LibrariesOverviewScreen> {
  @override
  void initState() {
    super.initState();

    LibrariesProvider.instance.fetchLibraries();
    LibrariesProvider.instance.addListener(() => setState(() {}));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(strings.librariesTitle),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // backgroundColor: ShelfishColors.librariesBackground,
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        children: [
          ...List.generate(
            LibrariesProvider.instance.libraries.length + 1,
            (int index) => GestureDetector(
              // Navigate to library screen.
              onTap: () async {
                // Prefetch handlers before async gaps.
                final NavigatorState navigator = Navigator.of(context);

                final int? libraryId = LibrariesProvider.instance.libraries[index].libraryElement.id;

                // Head out if, for any reason, the selected library has no id.
                if (libraryId == null) {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: Text(strings.warning),
                      content: Text(strings.genericError),
                    ),
                  );

                  return;
                }

                LibraryProvider.instance.fetchLibrary(libraryId);

                final Library library = await DatabaseHelper.instance.getLibrary(libraryId);

                navigator.push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LibraryScreen(
                      library: library,
                    ),
                  ),
                );
              },
              child: index < LibrariesProvider.instance.libraries.length
                  // Library preview.
                  ? Stack(
                      children: [
                        LibraryPreviewWidget(
                          library: LibrariesProvider.instance.libraries[index],
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              // Go to library info.
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => EditLibraryScreen(
                                    library: LibrariesProvider.instance.libraries[index],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.edit_rounded,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              _showDeleteDialog(LibrariesProvider.instance.libraries[index]);
                            },
                            icon: const Icon(
                              Icons.delete_rounded,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )

                  // All libraries.
                  : Card(
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "${strings.all} (${LibrariesProvider.instance.totalBooksCount} ${LibrariesProvider.instance.totalBooksCount == 1 ? strings.book : strings.books})",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 24.0,
        spaceBetweenChildren: 16.0,
        childrenButtonSize: const Size(64.0, 64.0),
        children: [
          SpeedDialChild(
            label: strings.importLib,
            child: const Icon(Icons.upload_rounded),
            onTap: () async {
              // Pick a library file.
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                // TODO
                // // Retrieve the file name.
                // String fileName = result.files.single.name.split(".").first;

                // // Read the file.
                // File file = File(result.files.single.path!);
                // String fileContent = await file.readAsString();

                // // Create and add the library to DB.
                // librariesProvider.addLibrary(Library.fromSerializableString(name: fileName, csvString: fileContent));
              } else {
                // User canceled the picker
              }
            },
          ),
          SpeedDialChild(
            label: strings.newLib,
            child: const Icon(Icons.note_add_rounded),
            onTap: () async {
              // Prefetch handlers before async gaps.
              final NavigatorState navigator = Navigator.of(context);

              // Navigate to library creation screen.
              await navigator.push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditLibraryScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(LibraryPreview library) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(strings.deleteLibraryTitle),
          content: Text(strings.deleteLibraryContent),
          actions: [
            TextButton(
              onPressed: () {
                // Prefetch handlers before async gaps.
                final NavigatorState navigator = Navigator.of(context);

                navigator.pop();
              },
              child: Text("cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Prefetch handlers before async gaps.
                final NavigatorState navigator = Navigator.of(context);

                await LibrariesProvider.instance.deleteLibrary(library);

                navigator.pop();
              },
              child: Text(strings.ok),
            ),
          ],
        );
      },
    );
  }
}
