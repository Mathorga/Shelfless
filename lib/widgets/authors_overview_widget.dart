import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/author_info_screen.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/utils/constants.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';

class AuthorsOverviewWidget extends StatelessWidget {
  final String searchValue;

  const AuthorsOverviewWidget({
    Key? key,
    this.searchValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthorsProvider authorsProvider = Provider.of(context, listen: true);
    final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

    // Fetch all relevant authors based on the currently viewed library. All if no specific library is selected.
    final List<Author> unfilteredAuthors = librariesProvider.currentLibrary != null
        ? librariesProvider.currentLibrary!.books
            .map<List<Author>>((Book book) => book.authors)
            .fold(<Author>[], (List<Author> result, List<Author> element) => result..addAll(element))
            .toSet()
            .toList()
        : authorsProvider.authors;
    // final List<Author> authors = unfilteredAuthors.where((Author author) => author.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: authorsProvider.authors.isEmpty
            ? const Center(
                child: Text("No authors found"),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                crossAxisCount: 2,
                children: [
                  ...List.generate(
                    authorsProvider.authors.length,
                    (int index) => Stack(
                      children: [
                        SizedBox(
                          height: double.infinity,
                          child: AuthorPreviewWidget(
                            author: authorsProvider.authors[index],
                            onTap: () {
                              if (librariesProvider.currentLibrary == null) {
                                return;
                              }

                              if (!librariesProvider.currentLibrary!.books.any((Book book) => book.authors.contains(authorsProvider.authors[index]))) {
                                return;
                              }

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => BooksScreen(
                                    authors: {authorsProvider.authors[index]},
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () {
                              // Edit the selected author.
                              Navigator.of(context).pushNamed(AuthorInfoScreen.routeName, arguments: authorsProvider.authors[index]);
                            },
                            icon: const Icon(Icons.settings_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: fabAccessHeight),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAuthorScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
