import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/themes/shelfless_colors.dart';
import 'package:shelfish/themes/themes.dart';

class AuthorPreviewWidget extends StatelessWidget {
  final Author author;
  final void Function()? onTap;

  /// Tells whether the widget should reflect the actual state of the given author or not.
  final bool live;

  const AuthorPreviewWidget({
    Key? key,
    required this.author,
    this.onTap,
    this.live = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

    final bool inCurrentLibrary = librariesProvider.authorInCurrentLibrary(author);

    final bool displayFull = !live || inCurrentLibrary;

    return GestureDetector(
      onTap: displayFull ? onTap : null,
      child: Card(
        color: displayFull ? Theme.of(context).cardColor : Theme.of(context).cardColor.withAlpha(0x7F),
        elevation: displayFull ? Theme.of(context).cardTheme.elevation : 0.0,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacing),
            child: Text(
              "${author.firstName} ${author.lastName}",
              textAlign: TextAlign.center,
              style: TextStyle(color: displayFull ? ShelflessColors.onMainContentActive : ShelflessColors.onMainContentInactive),
            ),
          ),
        ),
      ),
    );
  }
}
