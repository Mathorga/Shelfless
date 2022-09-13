import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/books_provider.dart';

import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/edit_library_screen.dart';
import 'package:shelfish/screens/library_screen.dart';
import 'package:shelfish/widgets/library_preview_widget.dart';

class LibrariesOverviewScreen extends StatelessWidget {
  static const String routeName = "/libraries_overview";

  const LibrariesOverviewScreen({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Libraries"),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    LibrariesProvider _librariesProvider = Provider.of(context, listen: true);
    BooksProvider _booksProvider = Provider.of(context, listen: true);

    final _libraries = _librariesProvider.libraries;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _libraries.isEmpty
          ? const Center(
              child: Text("No libraries found"),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  _libraries.length + 1,
                  (int index) => GestureDetector(
                    // Navigate to library screen.
                    onTap: () {
                      _librariesProvider.setCurrenLibraryIndex(index < _libraries.length ? index : null);
                      Navigator.of(context).pushNamed(LibraryScreen.routeName, arguments: index);
                    },
                    child: SizedBox(
                      height: 120.0,
                      child: index < _libraries.length
                          ? Stack(
                              children: [
                                LibraryPreviewWidget(
                                  library: _libraries[index],
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      // Go to library info.
                                      Navigator.of(context).pushNamed(EditLibraryScreen.routeName, arguments: _libraries[index]);
                                    },
                                    icon: const Icon(Icons.edit_rounded),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    onPressed: () {
                                      // Delete library.
                                      _librariesProvider.deleteLibrary(_libraries[index]);
                                    },
                                    icon: const Icon(Icons.delete_rounded),
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
                                    "All (${_booksProvider.books.length} books)",
                                    textAlign: TextAlign.center,
                                  ),
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
            label: "Import",
            child: const Icon(Icons.upload_rounded),
            onTap: () async {
              // Clear all cached files.
              FilePicker.platform.clearTemporaryFiles();

              // Pick a library file.
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                // Retrieve the file name.
                String fileName = result.files.single.name.split(".").first;

                // Read the file.
                File file = File(result.files.single.path!);
                String fileContent = await file.readAsString();

                // Create and add the library to DB.
                _librariesProvider.addLibrary(Library.fromSerializableString(name: fileName, csvString: fileContent));
              } else {
                // User canceled the picker
              }
            },
          ),
          SpeedDialChild(
            label: "New",
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
}
