import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shelfish/providers/authors_provider.dart';

import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';

class AuthorsOverviewWidget extends StatefulWidget {
  static const String routeName = "/authors_overview";

  const AuthorsOverviewWidget({Key? key}) : super(key: key);

  @override
  State<AuthorsOverviewWidget> createState() => _AuthorsOverviewWidgetState();
}

class _AuthorsOverviewWidgetState extends State<AuthorsOverviewWidget> {
  @override
  Widget build(BuildContext context) {
  final AuthorsProvider _authorsProvider = Provider.of(context, listen: true);
  
    return Scaffold(
        body: GridView.count(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          crossAxisCount: 2,
          children: [
            ...List.generate(
              _authorsProvider.authors.length,
              (int index) => AuthorPreviewWidget(
                author: _authorsProvider.authors[index],
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAuthorScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
