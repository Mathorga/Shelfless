import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_genre.dart';

class GenreLabelWidget extends StatelessWidget {
  final RawGenre genre;

  const GenreLabelWidget({
    super.key,
    required this.genre,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(genre.color),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                genre.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
