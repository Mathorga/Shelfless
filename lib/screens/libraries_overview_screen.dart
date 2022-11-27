import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/edit_library_screen.dart';
import 'package:shelfish/screens/library_screen.dart';
import 'package:shelfish/utils/strings.dart';
import 'package:shelfish/widgets/library_preview_widget.dart';

class LibrariesOverviewScreen extends StatelessWidget {
  static const String routeName = "/libraries_overview";

  const LibrariesOverviewScreen({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(EngStrings.librariesTitle),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    LibrariesProvider librariesProvider = Provider.of(context, listen: true);
    BooksProvider booksProvider = Provider.of(context, listen: true);

    final libraries = librariesProvider.libraries;

    return Scaffold(
      appBar: _buildAppBar(),
      // backgroundColor: ShelfishColors.librariesBackground,
      body: libraries.isEmpty
          ? const Center(
              child: Text(EngStrings.noLibrariesFound),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  libraries.length + 1,
                  (int index) => GestureDetector(
                    // Navigate to library screen.
                    onTap: () {
                      librariesProvider.setCurrenLibraryIndex(index < libraries.length ? index : null);
                      Navigator.of(context).pushNamed(LibraryScreen.routeName, arguments: index);
                    },
                    child: index < libraries.length
                        ? Stack(
                            children: [
                              LibraryPreviewWidget(
                                library: libraries[index],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    // Go to library info.
                                    Navigator.of(context).pushNamed(EditLibraryScreen.routeName, arguments: libraries[index]);
                                  },
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    _showDeleteDialog(context, libraries[index]);
                                  },
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 10.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Card(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "${EngStrings.all} (${booksProvider.books.length} ${EngStrings.books})",
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
            label: EngStrings.importLib,
            child: const Icon(Icons.upload_rounded),
            onTap: () async {
              // Pick a library file.
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                // Retrieve the file name.
                String fileName = result.files.single.name.split(".").first;

                // Read the file.
                File file = File(result.files.single.path!);
                String fileContent = await file.readAsString();

                // Create and add the library to DB.
                librariesProvider.addLibrary(Library.fromSerializableString(name: fileName, csvString: fileContent));
              } else {
                // User canceled the picker
              }
            },
          ),
          SpeedDialChild(
            label: EngStrings.newLib,
            child: const Icon(Icons.note_add_rounded),
            onTap: () {
              // Navigate to library creation screen.
              Navigator.of(context).pushNamed(EditLibraryScreen.routeName);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Library library) {
    LibrariesProvider librariesProvider = Provider.of(context, listen: false);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(EngStrings.deleteLibraryTitle),
            content: Text("${EngStrings.deleteLibraryContent} ${library.name}?"),
            actions: [
              TextButton(
                  onPressed: () {
                    // Actually delete the library.
                    librariesProvider.deleteLibrary(library);
                    Navigator.of(context).pop();
                  },
                  child: const Text(EngStrings.yes)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(EngStrings.no)),
            ],
          );
        });
  }
}
