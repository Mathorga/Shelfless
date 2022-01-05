import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/utils/books.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: books
            .map((Book book) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 12.0),
                        book.authors.length <= 2
                            ? Text(book.authors.map((Author author) => author.toString()).reduce((String value, String element) => "$value, $element"))
                            : Text("${book.authors.first}, altri"),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
