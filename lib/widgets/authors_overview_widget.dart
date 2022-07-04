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
  static const String routeName = "/authors_overview";

  final String searchValue;

  const AuthorsOverviewWidget({
    Key? key,
    this.searchValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthorsProvider _authorsProvider = Provider.of(context, listen: true);
    final LibrariesProvider _librariesProvider = Provider.of(context, listen: true);

    // Fetch all relevant authors based on the currently viewed library. All if no specific library is selected.
    final List<Author> _unfilteredAuthors = _librariesProvider.currentLibrary != null
        ? _librariesProvider.currentLibrary!.books
            .map<List<Author>>((Book book) => book.authors)
            .fold(<Author>[], (List<Author> result, List<Author> element) => result..addAll(element))
            .toSet()
            .toList()
        : _authorsProvider.authors;
    final _authors = _unfilteredAuthors.where((Author author) => author.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
        body: _authors.isEmpty
            ? const Center(
                child: Text("No authors found"),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                // crossAxisCount: 2,
                children: [
                  ...List.generate(
                    _authors.length,
                    (int index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BooksScreen(author: _authors[index]),
                        ),
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 120.0,
                            child: AuthorPreviewWidget(
                              author: _authors[index],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Edit the selected author.
                                Navigator.of(context).pushNamed(AuthorInfoScreen.routeName, arguments: _authors[index]);
                              },
                              icon: const Icon(Icons.info_rounded),
                            ),
                          ),
                        ],
                      ),
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
