import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/providers/books_provider.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/screens/book_info_screen.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';

class BooksOverviewWidget extends StatelessWidget {
  // The filter function is used to display a subset of all available books.
  // If no filter is provided, then all books are displayed.
  final bool Function(Book)? filter;

  final String searchValue;

  const BooksOverviewWidget({
    Key? key,
    this.filter,
    this.searchValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch the books provider and listen for changes.
    final BooksProvider _booksProvider = Provider.of(context, listen: true);
    final LibrariesProvider _librariesProvider = Provider.of(context, listen: true);

    // List<Book> _books = _booksProvider.books.where(filter ?? (Book book) => true).where((Book book) => book.title.toLowerCase().contains(searchValue.toLowerCase())).toList();
    List<Book> _unfilteredBooks = _librariesProvider.currentLibrary != null ? _librariesProvider.currentLibrary!.books : _booksProvider.books;
    List<Book> _books = _unfilteredBooks.where(filter ?? (Book book) => true).where((Book book) => book.title.toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _books.isEmpty
          ? const Center(
              child: Text("No books found"),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              children: [
                ...List.generate(
                  _books.length,
                  (int index) => BookPreviewWidget(
                    book: _books[index],
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => BookInfoScreen(book: _books[index]),
                    )),
                  ),
                )
              ],
            ),
      floatingActionButton: _librariesProvider.currentLibrary != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => const EditBookScreen(),
                ));
              },
              child: const Icon(Icons.add_rounded),
            )
          : null,
    );
  }
}
