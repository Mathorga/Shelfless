import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/themes/shelfless_colors.dart';
import 'package:shelfish/themes/themes.dart';

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
    final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

    final bool inCurrentLibrary = librariesProvider.authorInCurrentLibrary(author);

    return GestureDetector(
      onTap: inCurrentLibrary ? onTap : null,
      child: Card(
        color: inCurrentLibrary ? Theme.of(context).cardColor : Theme.of(context).cardColor.withAlpha(0x7F),
        elevation: inCurrentLibrary ? Theme.of(context).cardTheme.elevation : 0.0,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacing),
            child: Text(
              "${author.firstName} ${author.lastName}",
              textAlign: TextAlign.center,
              style: TextStyle(color: inCurrentLibrary ? ShelflessColors.onMainContentActive : ShelflessColors.onMainContentInactive),
            ),
          ),
        ),
      ),
    );
  }
}
