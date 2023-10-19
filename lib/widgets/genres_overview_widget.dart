import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shelfish/models/book.dart';

import 'package:shelfish/models/genre.dart';
import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/genre_info_screen.dart';
import 'package:shelfish/utils/strings/strings.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';

class GenresOverviewWidget extends StatefulWidget {
  final String searchValue;

  const GenresOverviewWidget({
    Key? key,
    this.searchValue = "",
  }) : super(key: key);

  @override
  State<GenresOverviewWidget> createState() => _GenresOverviewWidgetState();
}

class _GenresOverviewWidgetState extends State<GenresOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    final GenresProvider _genresProvider = Provider.of(context, listen: true);
    final LibrariesProvider _librariesProvider = Provider.of(context, listen: true);

    // Fetch all relevant genres based on the currently viewed library. All if no specific library is selected.
    final List<Genre> _unfilteredGenres = _librariesProvider.currentLibrary != null
        ? _librariesProvider.currentLibrary!.books
            .map<List<Genre>>((Book book) => book.genres)
            .fold(<Genre>[], (List<Genre> result, List<Genre> element) => result..addAll(element))
            .toSet()
            .toList()
        : _genresProvider.genres;
    final _genres = _unfilteredGenres.where((Genre genre) => genre.name.toLowerCase().contains(widget.searchValue.toLowerCase())).toList();

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: _genres.isEmpty
            ? Center(
                child: Text(strings.noGenresFound),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                childAspectRatio: 12 / 9,
                crossAxisCount: 2,
                children: [
                  ...List.generate(
                    _genres.length,
                    (int index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BooksScreen(
                            genres: {_genres[index]},
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          GenrePreviewWidget(
                            genre: _genres[index],
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Go to genre info.
                                Navigator.of(context).pushNamed(GenreInfoScreen.routeName, arguments: _genres[index]);
                              },
                              icon: const Icon(Icons.settings_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Create new genre.
            Navigator.of(context).pushNamed(EditGenreScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
