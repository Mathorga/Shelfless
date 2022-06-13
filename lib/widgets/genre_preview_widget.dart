import 'package:flutter/material.dart';

import 'package:shelfish/models/genre.dart';
import 'package:shelfish/utils/color_utils.dart';

class GenrePreviewWidget extends StatelessWidget {
  final Genre genre;

  const GenrePreviewWidget({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: genreColor(genre.color),
      elevation: 0.0,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            genre.name,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
