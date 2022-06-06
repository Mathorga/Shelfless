import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/widgets/authors_overview_widget.dart';
import 'package:shelfish/widgets/genres_overview_widget.dart';
import 'package:shelfish/screens/locations_overview_screen.dart';
import 'package:shelfish/widgets/books_overview_widget.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/main";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  AppBar _buildAppBar(BooksProvider booksProvider) {
    return AppBar(
      title: const Text("Shelfish"),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the books provider.
    final BooksProvider booksProvider = Provider.of(context, listen: false);
    const List<Widget> _pages = [
      GenresOverviewWidget(),
      AuthorsOverviewWidget(),
      BooksOverviewWidget(),
    ];

    return Scaffold(
      appBar: _buildAppBar(booksProvider),
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
