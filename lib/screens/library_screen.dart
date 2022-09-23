import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/libraries_overview_screen.dart';
import 'package:shelfish/themes/shelfish_colors.dart';
import 'package:shelfish/widgets/authors_overview_widget.dart';
import 'package:shelfish/widgets/genres_overview_widget.dart';
import 'package:shelfish/widgets/books_overview_widget.dart';
import 'package:shelfish/widgets/locations_overview_widget.dart';
import 'package:shelfish/widgets/publishers_overview_widget.dart';

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
      PublishersOverviewWidget(searchValue: _currentFilter),
      LocationsOverviewWidget(searchValue: _currentFilter),
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
            PopupMenuButton(
              itemBuilder: (BuildContext context) => const [
                PopupMenuItem(
                  value: 0,
                  child: Text("Share"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("Export"),
                ),
              ],
              onSelected: (int value) async {
                switch (value) {
                  case 0:
                    // Share to external app.

                    // Save the library file locally.
                    Directory tmpDir = await getTemporaryDirectory();
                    String libraryFilePath = "${tmpDir.path}/${_librariesProvider.currentLibrary!.name}.csv";
                    _librariesProvider.currentLibrary!.writeToFile(libraryFilePath);

                    // Share the file that was just saved.
                    Share.shareFiles([libraryFilePath]);
                    break;
                  case 1:
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

                    // Write the library to file.
                    _librariesProvider.currentLibrary!.writeToFile("$path/${_librariesProvider.currentLibrary!.name}.csv");
                    break;
                  default:
                    break;
                }
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        onTap: (int selectedIndex) => setState(() => _currentIndex = selectedIndex),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedItemColor: Theme.of(context).colorScheme.onBackground,
        selectedIconTheme: IconTheme.of(context).copyWith(color: Theme.of(context).colorScheme.primary, size: 28.0,),
        unselectedIconTheme: IconTheme.of(context).copyWith(size: 22.0),
        backgroundColor: Colors.transparent,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_rounded),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.location_city_rounded),
            label: "Publishers",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome_mosaic_rounded),
            label: "Locations",
          ),
        ],
      ),
      body: Center(
        child: _pages[_currentIndex],
      ),
    );
  }
}
