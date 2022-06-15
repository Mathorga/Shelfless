import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shelfish/models/genre.dart';

import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/genre_info_screen.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';

class GenresOverviewWidget extends StatefulWidget {
  static const String routeName = "/genres_overview";

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
    final _genres = _genresProvider.genres.where((Genre genre) => genre.name.toLowerCase().contains(widget.searchValue.toLowerCase())).toList();

    return Scaffold(
        body: _genres.isEmpty
            ? const Center(
                child: Text("No genres yet"),
              )
            : GridView.count(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                crossAxisCount: 2,
                children: [
                  ...List.generate(
                    _genres.length,
                    (int index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BooksScreen(
                            genre: _genres[index],
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
                              icon: const Icon(Icons.info_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
