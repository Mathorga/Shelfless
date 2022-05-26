import 'dart:math';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/genre.dart';

class EditGenreScreen extends StatefulWidget {
  static const String routeName = "/edit-genre";

  const EditGenreScreen({Key? key}) : super(key: key);

  @override
  _EditGenreScreenState createState() => _EditGenreScreenState();
}

class _EditGenreScreenState extends State<EditGenreScreen> {
  final Box<Genre> genres = Hive.box<Genre>("genres");

  String name = "";
  int color = Colors.white.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Genre"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Name"),
            TextField(
              onChanged: (String value) => name = value,
            ),
            const SizedBox(
              height: 24.0,
              child: Divider(height: 2.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Actually save a new genre.
          final Genre genre = Genre(
            name: name.trim(),
            color: (Random().nextDouble() * 0xFFFFFFFF).toInt(),
          );
          genres.add(genre);
          Navigator.of(context).pop();
        },
        label: Row(
          children: const [
            Text("Done"),
            SizedBox(width: 12.0),
            Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
