import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
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
              icon: const Icon(Icons.output_rounded),
              onPressed: () {
                _librariesProvider.currentLibrary!.books.forEach((Book book) => print(book.toMap().toString()));
                // TODO Export the current library to a file.
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
