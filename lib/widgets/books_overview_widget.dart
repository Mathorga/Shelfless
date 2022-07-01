import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/screens/book_info_screen.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/widgets/book_preview_widget.dart';

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

    List<Book> _books = _booksProvider.books.where(filter ?? (Book book) => true).where((Book book) => book.title.toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
      body: _books.isEmpty
          ? const Center(
              child: Text("No books found"),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  _books.length,
                  (int index) => BookPreviewWidget(
                    book: _books[index],
                    onTap: () => Navigator.of(context).pushNamed(BookInfoScreen.routeName, arguments: _books[index]),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditBookScreen.routeName);
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
