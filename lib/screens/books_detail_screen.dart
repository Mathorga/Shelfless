import 'package:flutter/material.dart';

import 'package:dismissible_page/dismissible_page.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/element_action.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/book_details_widget.dart';

class BooksDetailScreen extends StatefulWidget {
  final Book openingBook;

  const BooksDetailScreen({
    super.key,
    required this.openingBook,
  });

  @override
  State<BooksDetailScreen> createState() => _BooksDetailScreenState();
}

class _BooksDetailScreenState extends State<BooksDetailScreen> {
  late Book _book;

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();

    _book = widget.openingBook;

    _pageController = PageController(
      initialPage: LibraryContentProvider.instance.books.indexOf(_book),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        final NavigatorState navigator = Navigator.of(context);

        navigator.pop();
      },
      isFullScreen: true,
      direction: DismissiblePageDismissDirection.down,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
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
                    // Open EditBookScreen.
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => EditBookScreen(
                        book: _book,
                        onDone: (Book book) => setState(() {
                          _book = book;
                        }),
                      ),
                    ));
                    break;
                  case ElementAction.toggleOut:
                  case ElementAction.moveTo:
                    break;
                  case ElementAction.delete:
                    final NavigatorState navigator = Navigator.of(context);
      
                    final bool? deleted = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(strings.deleteBookTitle),
                        content: Text(strings.deleteBookContent),
                        actions: [
                          // Cancel button.
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
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
                              LibraryContentProvider.instance.deleteBook(_book);
      
                              messenger.showSnackBar(
                                SnackBar(
                                  duration: Themes.durationShort,
                                  content: Text(
                                    strings.bookDeleted,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
      
                              // Pop dialog.
                              navigator.pop(true);
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
      
                    // Pop back if the book was deleted.
                    if (deleted == true) navigator.pop();
      
                    break;
                }
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: PageView.builder(
          controller: _pageController,
          physics: PageScrollPhysics(),
          itemCount: LibraryContentProvider.instance.books.length,
          onPageChanged: (int index) {
            _book = LibraryContentProvider.instance.books[index];
          },
          itemBuilder: (BuildContext context, int index) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              LibraryContentProvider.instance.addListener(() {
                if (mounted) setState(() {});
              });
              
              final Book pageBook = LibraryContentProvider.instance.books[index];
              
              return BookDetailsWidget(
                book: pageBook,
              );
            },
          ),
        ),
      ),
    );
  }
}
