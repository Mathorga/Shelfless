import 'package:flutter/material.dart';

import 'package:shelfish/models/library.dart';

class LibraryPreviewWidget extends StatelessWidget {
  final Library library;

  const LibraryPreviewWidget({
    Key? key,
    required this.library,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            library.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
