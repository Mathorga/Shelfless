import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class AuthorLabelWidget extends StatelessWidget {
  final Author author;

  const AuthorLabelWidget({
    super.key,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ShelflessColors.mainContentActive,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$author",
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
