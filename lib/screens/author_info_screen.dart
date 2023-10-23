import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfless/dialogs/delete_dialog.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/authors_provider.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';

class AuthorInfoScreen extends StatelessWidget {
  static const String routeName = "/author-info";

  final Author author;

  const AuthorInfoScreen({
    Key? key,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch provider.
    final AuthorsProvider _authorsProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.authorInfo,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to edit_book_screen.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => EditAuthorScreen(
                    author: author,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {
              // Show dialog asking the user to confirm their choice.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteDialog(
                    title: Text("$author"),
                    onConfirm: () => _authorsProvider.deleteAuthor(author),
                  );
                },
              );
            },
            icon: const Icon(Icons.delete_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First name.
              Text(strings.firstName),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(author.firstName, style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(
                height: 24.0,
              ),

              // Last name.
              Text(strings.lastName),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(author.lastName, style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
