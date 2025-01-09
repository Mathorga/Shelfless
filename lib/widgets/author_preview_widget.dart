import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class AuthorPreviewWidget extends StatelessWidget {
  final Author author;
  final void Function()? onTap;

  const AuthorPreviewWidget({
    Key? key,
    required this.author,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: Theme.of(context).cardTheme.elevation,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: Text(
              "${author.firstName} ${author.lastName}",
              textAlign: TextAlign.center,
              style: TextStyle(color: ShelflessColors.onMainContentActive),
            ),
          ),
        ),
      ),
    );
  }
}
