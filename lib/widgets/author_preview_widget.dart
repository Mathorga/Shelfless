import 'package:flutter/material.dart';

import 'package:shelfish/models/author.dart';

class AuthorPreviewWidget extends StatelessWidget {
  final Author author;

  const AuthorPreviewWidget({
    Key? key,
    required this.author,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "${author.firstName} ${author.lastName}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
