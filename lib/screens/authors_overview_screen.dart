import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/author_info_screen.dart';
import 'package:shelfless/screens/books_screen.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_preview_widget.dart';

class AuthorsOverviewScreen extends StatelessWidget {
  final String searchValue;

  const AuthorsOverviewScreen({
    super.key,
    this.searchValue = "",
  });

  @override
  Widget build(BuildContext context) {
    // final List<Author> authors = authorsProvider.authors.where((Author author) => author.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(strings.authorsSectionTitle),
        ),
        // backgroundColor: Colors.transparent,
        body: LibraryContentProvider.instance.authors.isEmpty
            ? Center(
                child: Text(strings.noAuthorsFound),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                crossAxisCount: 2,
                children: [
                  ...List.generate(
                    LibraryContentProvider.instance.authors.length,
                    (int index) {
                      // Make sure the received index is somewhat valid.
                      if (index > LibraryContentProvider.instance.authors.values.length) return const Placeholder();

                      // Prefetch the genre for later use.
                      Author? author = LibraryContentProvider.instance.authors.values.toList()[index];

                      return Stack(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            child: AuthorPreviewWidget(
                              author: author,
                              onTap: () {
                                // if (!librariesProvider.currentLibrary!.books.any((Book book) => book.authors.contains(authors[index]))) {
                                //   return;
                                // }

                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) => BooksScreen(
                                //       authors: {authors[index]},
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Edit the selected author.
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (BuildContext context) => AuthorInfoScreen(author: authors[index]),
                                //   ),
                                // );
                              },
                              icon: const Icon(Icons.settings_rounded),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: fabAccessHeight),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => const EditAuthorScreen(),
              ),
            );
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
