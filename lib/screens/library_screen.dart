import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

import 'package:shelfish/models/library.dart';
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
    // Define all pages.
    List<Widget> _pages = [
      GenresOverviewWidget(searchValue: _currentFilter),
      AuthorsOverviewWidget(searchValue: _currentFilter),
      BooksOverviewWidget(searchValue: _currentFilter),
    ];

    return Scaffold(
      appBar: EasySearchBar(
        title: const Text("Shelfish"),
        searchBackIconTheme: const IconThemeData(color: Colors.white),
        searchCursorColor: Colors.white,
        onSearch: (String value) {
          setState(() {
            _currentFilter = value;
          });
        },
        actions: [
          IconButton(
            icon: const Icon(Icons.output_rounded),
            onPressed: () {
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
            icon: Icon(Icons.category_rounded),
            label: "Genres",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Authors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_rounded),
            label: "Books",
          ),
        ],
      ),
      body: Center(
        child: _pages[_currentIndex],
      ),
    );
  }
}
