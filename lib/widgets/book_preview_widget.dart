import 'package:flutter/material.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/element_action.dart';
import 'package:shelfless/utils/material_utils.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/utils/view_mode.dart';
import 'package:shelfless/widgets/book_genres_box_widget.dart';
import 'package:shelfless/widgets/book_thumbnail_widget.dart';
import 'package:shelfless/widgets/delete_dialog.dart';

class BookPreviewWidget extends StatelessWidget {
  final Book book;
  final ViewMode viewMode;
  final void Function()? onTap;
  final void Function()? onDoubleTap;

  const BookPreviewWidget({
    super.key,
    required this.book,
    this.viewMode = ViewMode.extendedGrid,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    final List<Author> authors = book.authorIds
        .map((int authorId) {
          return LibraryContentProvider.instance.authors[authorId];
        })
        .nonNulls
        .toList();

    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: switch (viewMode) {
        // List view.
        ViewMode.list => Card(
            child: BookGenresBoxWidget(
              book: book,
              child: Padding(
                padding: const EdgeInsets.all(Themes.spacingSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(book.raw.title),
                    ),
                    _buildPopupMenuButton(context),
                  ],
                ),
              ),
            ),
          ),

        // Compact grid view.
        ViewMode.compactGrid => Stack(
            children: [
              BookThumbnailWidget(
                book: book,
                showOutBanner: true,
                overlay: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: Themes.foregroundHighlightOpacity),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                child: _buildPopupMenuButton(context),
              )
            ],
          ),

        // Extended grid view.
        ViewMode.extendedGrid => Column(
            spacing: Themes.spacingMedium,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BookThumbnailWidget(
                book: book,
                showOutBanner: true,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Themes.spacingSmall),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        spacing: Themes.spacingXSmall,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Title.
                          Text(
                            book.raw.title,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),

                          // Authors.
                          if (authors.isNotEmpty)
                            Text(
                              authors.length <= 2
                                  ? authors.map((Author author) => author.toString()).reduce((String value, String element) => "$value, $element")
                                  : "${authors.first}, others",
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w300,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ],
                      ),
                    ),
                    _buildPopupMenuButton(context),
                  ],
                ),
              ),
            ],
          ),
      },
    );
  }

  Widget _buildPopupMenuButton(BuildContext context) {
    return PopupMenuButton<ElementAction>(
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

          // Only show the "move to" button if there's a single library open.
          if (LibraryContentProvider.instance.editable)
            PopupMenuItem(
              value: ElementAction.moveTo,
              child: Row(
                spacing: Themes.spacingSmall,
                children: [
                  const Icon(Icons.move_up_rounded),
                  Text(strings.bookMoveTo),
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
            // Open EditBookScreen.
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => EditBookScreen(
                book: book,
              ),
            ));
            break;
          case ElementAction.moveTo:
            MaterialUtils.moveBookTo(context, book: book);
            break;
          case ElementAction.delete:
            showDialog(
              context: context,
              builder: (BuildContext context) => DeleteDialog(
                titleString: strings.deleteBookTitle,
                contentString: strings.deleteBookContent,
                onConfirm: () async {
                  // Prefetch handlers before async gaps.
                  final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

                  // Delete the book.
                  await LibraryContentProvider.instance.deleteBook(book);

                  messenger.showSnackBar(
                    SnackBar(
                      duration: Themes.durationShort,
                      behavior: SnackBarBehavior.floating,
                      width: Themes.snackBarSizeSmall,
                      content: Text(
                        strings.bookDeleted,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            );
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(Themes.spacingSmall),
        child: Icon(Icons.more_vert_rounded),
      ),
    );
  }
}
