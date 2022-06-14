import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/widgets/delete_dialog.dart';

class AuthorInfoScreen extends StatefulWidget {
  static const String routeName = "/author-info";

  const AuthorInfoScreen({Key? key}) : super(key: key);

  @override
  State<AuthorInfoScreen> createState() => _AuthorInfoScreenState();
}

class _AuthorInfoScreenState extends State<AuthorInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch provider.
    final AuthorsProvider authorsProvider = Provider.of(context, listen: true);

    // Fetch book.
    Author author = ModalRoute.of(context)!.settings.arguments as Author;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Author Info",
          style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to edit_book_screen.
              Navigator.of(context).pushNamed(EditAuthorScreen.routeName, arguments: author);
            },
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {
              // Show dialog asking the user to confirm their choice.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteDialog(title: author.toString(), onYes: () => authorsProvider.deleteAuthor(author), onNo: null);
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
              const Text("First Name"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(author.firstName, style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(
                height: 24.0,
              ),

              // Last name.
              const Text("Last Name"),
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
