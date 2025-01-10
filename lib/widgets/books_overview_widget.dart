import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/book_info_screen.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';

class BooksOverviewWidget extends StatefulWidget {
  const BooksOverviewWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<BooksOverviewWidget> createState() => _BooksOverviewWidgetState();
}

class _BooksOverviewWidgetState extends State<BooksOverviewWidget> {
  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LibraryContentProvider.instance.books.isEmpty
          ? const Center(
              child: Text("No books found"),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(12.0),
              children: [
                ...List.generate(
                  LibraryContentProvider.instance.books.length,
                  (int index) => BookPreviewWidget(
                    book: LibraryContentProvider.instance.books[index],
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
