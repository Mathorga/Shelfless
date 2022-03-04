import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';

class EditAuthorScreen extends StatefulWidget {
  static const String routeName = "/edit-author";

  const EditAuthorScreen({Key? key}) : super(key: key);

  @override
  _EditAuthorScreenState createState() => _EditAuthorScreenState();
}

class _EditAuthorScreenState extends State<EditAuthorScreen> {
  final Box<Author> authors = Hive.box<Author>("authors");

  String firstName = "";
  String lastName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Author"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("First Name"),
            TextField(
              onChanged: (String value) => firstName = value,
            ),
            const SizedBox(
              height: 24.0,
              child: Divider(height: 2.0),
            ),
            const Text("Last Name"),
            TextField(
              onChanged: (String value) => lastName = value,
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
          // Actually save a new author.
          final Author author = Author(firstName.trim(), lastName.trim());
          authors.add(author);
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
