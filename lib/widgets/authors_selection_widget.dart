import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_preview_widget.dart';
import 'package:shelfless/widgets/selection_widget.dart';

class AuthorsSelectionWidget extends StatefulWidget {
  /// Already selected author ids.
  final List<int?> selectedAuthorIds;

  /// Whether the widget should allow the user to add a new author if not present already.
  final bool insertNew;

  /// Called when a new set of authors is selected from the source list,
  final void Function(Set<int?> authorIds)? onAuthorsSelected;

  /// Called when an author is removed from the selection list.
  final void Function(int authorId)? onAuthorUnselected;

  AuthorsSelectionWidget({
    super.key,
    List<int?>? inAuthorIds,
    this.insertNew = false,
    this.onAuthorsSelected,
    this.onAuthorUnselected,
  }) : selectedAuthorIds = inAuthorIds ?? [];

  @override
  State<AuthorsSelectionWidget> createState() => _AuthorsSelectionWidgetState();
}

class _AuthorsSelectionWidgetState extends State<AuthorsSelectionWidget> {
  final SelectionController _selectionController = SelectionController(
    sourceIds: LibraryContentProvider.instance.authors.keys.toList(),
  );

  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      _selectionController.setIds(LibraryContentProvider.instance.authors.keys.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SelectionWidget(
      title: strings.bookInfoAuthors,
      controller: _selectionController,
      inSelectedIds: widget.selectedAuthorIds,
      onInsertNewRequested: widget.insertNew
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditAuthorScreen(),
                ),
              );
            }
          : null,
      onItemsSelected: widget.onAuthorsSelected,
      onItemUnselected: widget.onAuthorUnselected,
      listItemsFilter: (int? authorId, String? filter) => filter != null ? LibraryContentProvider.instance.authors[authorId].toString().toLowerCase().contains(filter) : true,
      listItemBuilder: (int? id) {
        final Author? author = LibraryContentProvider.instance.authors[id];

        if (author == null) return Placeholder();

        return AuthorPreviewWidget(author: author);
      },
    );
  }
}
