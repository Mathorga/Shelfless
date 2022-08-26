import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/widgets/authors_overview_widget.dart';
import 'package:shelfish/widgets/genres_overview_widget.dart';
import 'package:shelfish/widgets/books_overview_widget.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = "/library";

  const LibraryScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _currentIndex = 0;
  String _currentFilter = "";

  @override
  Widget build(BuildContext context) {
    LibrariesProvider _librariesProvider = Provider.of(context, listen: true);

    // Define all pages.
    List<Widget> _pages = [
      BooksOverviewWidget(searchValue: _currentFilter),
      GenresOverviewWidget(searchValue: _currentFilter),
      AuthorsOverviewWidget(searchValue: _currentFilter),
    ];

    return Scaffold(
      appBar: EasySearchBar(
        title: Text(_librariesProvider.currentLibrary != null ? _librariesProvider.currentLibrary!.name : "All"),
        searchBackIconTheme: const IconThemeData(color: Colors.white),
        searchCursorColor: Colors.white,
        onSearch: (String value) {
          setState(() {
            _currentFilter = value;
          });
        },
        actions: [
          // Only display the export button if actually displaying a single library.
          if (_librariesProvider.currentLibrary != null)
            IconButton(
              // icon: const Icon(Icons.output_rounded),
              icon: const Icon(Icons.share_rounded),
              onPressed: () async {
                // Export the current library to a file.

                // Ask for permission to read and write to external storage.
                if (!await Permission.storage.request().isGranted) {
                  // Either the permission was already denied before or the user just denied it.
                  return;
                }

                // Ask for permission to access all user accessible directories.
                if (!await Permission.manageExternalStorage.request().isGranted) {
                  // Either the permission was already denied before or the user just denied it.
                  return;
                }

                // Let the user pick the destination directory.
                String? path = await FilePicker.platform.getDirectoryPath();

                if (path == null) {
                  // User canceled the picker or the path is not resolved.
                  return;
                }

                // Open a new text file using the library name.
                final File libraryFile = await File("$path/${_librariesProvider.currentLibrary!.name}.csv").create(recursive: true);

                // Write the file.
                // No need to await for this one, as it's the last operation.
                libraryFile.writeAsString(_librariesProvider.currentLibrary!.toSerializableString());
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        onTap: (int selectedIndex) => setState(() => _currentIndex = selectedIndex),
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: "Books",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: "Genres",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Authors",
          ),
        ],
      ),
      body: Center(
        child: _pages[_currentIndex],
      ),
    );
  }
}
