import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/element_action.dart';
import 'package:shelfless/utils/strings/strings.dart';

class AuthorPreviewWidget extends StatelessWidget {
  final Author author;
  final void Function()? onTap;

  const AuthorPreviewWidget({
    super.key,
    required this.author,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$author",
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      author.nationality.isNotEmpty ? author.nationality : "-",
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: ShelflessColors.onMainContentInactive,
                      ),
                    ),
                  ],
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
                  onSelected: (ElementAction value) {
                    switch (value) {
                      case ElementAction.edit:
                        // Open EditAuthorScreen.
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => EditAuthorScreen(
                            author: author,
                          ),
                        ));
                        break;
                      case ElementAction.delete:
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(strings.deleteBookTitle),
                            content: Text(strings.deleteBookContent),
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

                                  // Delete the book.
                                  // await LibraryContentProvider.instance.deleteBook(book);

                                  messenger.showSnackBar(
                                    SnackBar(
                                      // margin: const EdgeInsets.all(Themes.spacingMedium),
                                      duration: Themes.durationShort,
                                      behavior: SnackBarBehavior.floating,
                                      width: Themes.snackBarSizeSmall,
                                      content: Text(
                                        strings.bookDeleted,
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
