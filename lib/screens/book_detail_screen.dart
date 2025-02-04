import 'package:flutter/material.dart';

import 'package:blur/blur.dart';
import 'package:shadow_overlay/shadow_overlay.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';
import 'package:shelfless/widgets/book_thumbnail_widget.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;

  const BookDetailScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final EdgeInsets mediaQueryPadding = MediaQuery.paddingOf(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton<BookAction>(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: BookAction.edit,
                  child: Row(
                    spacing: Themes.spacingSmall,
                    children: [
                      const Icon(Icons.edit_rounded),
                      Text(strings.bookEdit),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: BookAction.delete,
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
            onSelected: (BookAction value) async {
              switch (value) {
                case BookAction.edit:
                  // Open EditBookScreen.
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EditBookScreen(
                      book: book,
                    ),
                  ));
                  break;
                case BookAction.moveTo:
                  break;
                case BookAction.delete:
                  final NavigatorState navigator = Navigator.of(context);

                  await showDialog(
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
                            await LibraryContentProvider.instance.deleteBook(book);

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

                            // Pop dialog.
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

                  // Pop back.
                  navigator.pop();
                  break;
              }
            },
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // I personally don't like this widget very much, so TODO find a replacement.
          // Maybe using a ShaderMask widget would be a better solution.
          ShadowOverlay(
            shadowWidth: MediaQuery.sizeOf(context).width,
            shadowHeight: 150.0,
            shadowColor: theme.colorScheme.surface,
            child: Blur(
              blur: 20.0,
              blurColor: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                child: Image.memory(
                  book.raw.cover!,
                  fit: BoxFit.cover,
                  isAntiAlias: false,
                  filterQuality: FilterQuality.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: Themes.scrollPhysics,
            child: Column(
              spacing: Themes.spacingLarge,
              children: [
                // Cover.
                Column(
                  spacing: Themes.spacingXLarge,
                  children: [
                    // Top padding.
                    SizedBox(
                      height: mediaQueryPadding.top,
                    ),
                    Center(
                      child: BookThumbnailWidget(
                        book: book,
                        showOutBanner: true,
                      ),
                    ),
                  ],
                ),

                // Title, edition and publication year.
                Column(
                  children: [
                    // TItle.
                    Center(
                      child: Text(
                        book.raw.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // TODO Edition.

                    // Publication year.
                    Center(
                      child: Text(
                        "${book.raw.publishYear}",
                      ),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Authors.
                    Padding(
                      padding: const EdgeInsets.all(Themes.spacingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(strings.authorsSectionTitle),
                          Padding(
                            padding: const EdgeInsets.all(Themes.spacingMedium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: book.authorIds.map((int authorId) => Text(LibraryContentProvider.instance.authors[authorId].toString())).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Genres.
                    Padding(
                      padding: const EdgeInsets.all(Themes.spacingLarge),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(strings.genresSectionTitle),
                          Padding(
                            padding: const EdgeInsets.all(Themes.spacingMedium),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: book.genreIds.map((int genreId) => Text(LibraryContentProvider.instance.genres[genreId].toString())).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Actions.
                Padding(
                  padding: const EdgeInsets.all(Themes.spacingMedium),
                  child: Row(
                    spacing: Themes.spacingSmall,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildAction(
                          context,
                          onPressed: () {},
                          label: book.raw.out ? strings.bookMarkInAction : strings.bookMarkOutAction,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: _buildAction(
                          context,
                          label: strings.bookMoveTo,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    void Function()? onPressed,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: ShelflessColors.onMainContentActive,
        backgroundColor: ShelflessColors.mainContentInactive,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Themes.spacingMedium),
        child: Text(
          label,
        ),
      ),
    );
  }
}
