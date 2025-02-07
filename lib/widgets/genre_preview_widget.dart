import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/element_action.dart';
import 'package:shelfless/utils/strings/strings.dart';

class GenrePreviewWidget extends StatelessWidget {
  final RawGenre genre;
  final void Function()? onTap;

  const GenrePreviewWidget({
    super.key,
    required this.genre,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
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
                PopupMenuButton<ElementAction>(
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: ElementAction.edit,
                        child: Row(
                          spacing: Themes.spacingSmall,
                          children: [
                            const Icon(Icons.edit_rounded),
                            Text(strings.bookEdit),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: ElementAction.delete,
                        child: Row(
                          spacing: Themes.spacingSmall,
                          children: [
                            const Icon(Icons.delete_rounded),
                            Text(strings.bookDeleteAction),
                          ],
                        ),
                      ),
                    ];
                  },
                  onSelected: (ElementAction value) async {
                    switch (value) {
                      case ElementAction.edit:
                        // Open EditGenreScreen.
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => EditGenreScreen(
                            genre: genre,
                          ),
                        ));
                        break;
                      case ElementAction.delete:
                        final bool genreIsRogue = await LibraryContentProvider.instance.isGenreRogue(genre);

                        if (context.mounted) {
                          if (!genreIsRogue) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text(strings.genericCannotDelete),
                                content: Text(strings.cannotDeleteGenreContent),
                              ),
                            );
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(strings.deleteGenreTitle),
                              content: Text(strings.deleteGenreContent),
                              actions: [
                                // Cancel button.
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: TextButton.styleFrom(
                                    foregroundColor: ShelflessColors.onMainContentActive,
                                  ),
                                  child: Text(strings.cancel),
                                ),

                                // Confirm button.
                                ElevatedButton(
                                  onPressed: () async {
                                    // Prefetch handlers before async gaps.
                                    final NavigatorState navigator = Navigator.of(context);
                                    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

                                    // Delete the author.
                                    await LibraryContentProvider.instance.deleteGenre(genre);

                                    messenger.showSnackBar(
                                      SnackBar(
                                        // margin: const EdgeInsets.all(Themes.spacingMedium),
                                        duration: Themes.durationShort,
                                        behavior: SnackBarBehavior.floating,
                                        width: Themes.snackBarSizeSmall,
                                        content: Text(
                                          strings.genreDeleted,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );

                                    // Pop back.
                                    navigator.pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: ShelflessColors.error,
                                    iconColor: ShelflessColors.onMainContentActive,
                                    foregroundColor: ShelflessColors.onMainContentActive,
                                  ),
                                  child: Text(strings.ok),
                                ),
                              ],
                            ),
                          );
                        }
                        break;
                      default:
                        break;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(Themes.spacingSmall),
                    child: Icon(
                      Icons.more_vert_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
