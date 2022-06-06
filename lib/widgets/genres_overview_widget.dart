import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shelfish/models/book.dart';

import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';

class GenresOverviewWidget extends StatefulWidget {
  static const String routeName = "/genres_overview";

  const GenresOverviewWidget({Key? key}) : super(key: key);

  @override
  State<GenresOverviewWidget> createState() => _GenresOverviewWidgetState();
}

class _GenresOverviewWidgetState extends State<GenresOverviewWidget> {
  @override
  Widget build(BuildContext context) {
    final GenresProvider _genresProvider = Provider.of(context, listen: true);

    return Scaffold(
        body: GridView.count(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 2,
          children: [
            ...List.generate(
              _genresProvider.genres.length,
              (int index) => GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => BooksScreen(
                      genre: _genresProvider.genres[index],
                    ),
                  ),
                ),
                child: GenrePreviewWidget(
                  genre: _genresProvider.genres[index],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditGenreScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
