import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/screens/book_info_screen.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';

class BooksOverviewWidget extends StatefulWidget {
  final List<Book> books;

  const BooksOverviewWidget({
    Key? key,
    this.books = const [],
  }) : super(key: key);

  @override
  State<BooksOverviewWidget> createState() =>
      _filteredBooksOverviewWidgetState();
}

class _filteredBooksOverviewWidgetState extends State<BooksOverviewWidget> {
  List<Book> _filteredBooks = [];

  @override
  void initState() {
    super.initState();

    _filteredBooks = [...widget.books];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _filteredBooks.isEmpty
          ? const Center(
              child: Text("No books found"),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              children: [
                ...List.generate(
                  _filteredBooks.length,
                  (int index) => BookPreviewWidget(
                    book: _filteredBooks[index],
                    // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (BuildContext context) => BookInfoScreen(
                    //     book: _filteredBooks[index],
                    //   ),
                    // )),
                  ),
                )
              ],
            ),
      // floatingActionButton: _librariesProvider.currentLibrary != null
      //     ? FloatingActionButton(
      //         onPressed: () {
      //           Navigator.of(context).push(MaterialPageRoute(
      //             builder: (BuildContext context) => const EditBookScreen(),
      //           ));
      //         },
      //         child: const Icon(Icons.add_rounded),
      //       )
      //     : null,
    );
  }
}
