import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';

class AuthorsOverviewScreen extends StatefulWidget {
  static const String routeName = "/authors_overview";

  const AuthorsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<AuthorsOverviewScreen> createState() => _AuthorsOverviewScreenState();
}

class _AuthorsOverviewScreenState extends State<AuthorsOverviewScreen> {
  final Box<Author> _authors = Hive.box<Author>("authors");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Authors"),
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
              _authors.length,
              (int index) => AuthorPreviewWidget(
                author: _authors.getAt(index)!,
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
