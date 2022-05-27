import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';

class GenresOverviewScreen extends StatefulWidget {
  static const String routeName = "/genres_overview";

  const GenresOverviewScreen({Key? key}) : super(key: key);

  @override
  State<GenresOverviewScreen> createState() => _GenresOverviewScreenState();
}

class _GenresOverviewScreenState extends State<GenresOverviewScreen> {
  final Box<Genre> _genres = Hive.box<Genre>("genres");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Genres"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              onSelected: (String item) {},
              tooltip: "Sort by",
              itemBuilder: (BuildContext context) {
                return {
                  "Title",
                  "Author",
                  "Genre",
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          children: [
            ...List.generate(
              _genres.length,
              (int index) => GenrePreviewWidget(
                genre: _genres.getAt(index)!,
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
