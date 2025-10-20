import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_label_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/selection_widget/multiple_selection_widget.dart';

class AuthorsSelectionWidget extends StatefulWidget {
  /// Already selected author ids.
  final Set<int?> inSelectedIds;

  /// Whether the widget should allow the user to add a new author if not present already.
  final bool insertNew;

  /// Called when a new set of authors is selected from the source list,
  final void Function(Set<int?> authorIds)? onAuthorsSelected;

  /// Called when an author is removed from the selection list.
  final void Function(int authorId)? onAuthorUnselected;

  const AuthorsSelectionWidget({
    super.key,
    this.inSelectedIds = const {},
    this.insertNew = false,
    this.onAuthorsSelected,
    this.onAuthorUnselected,
  });

  @override
  State<AuthorsSelectionWidget> createState() => _AuthorsSelectionWidgetState();
}

class _AuthorsSelectionWidgetState extends State<AuthorsSelectionWidget> {
  late final SelectionController<int?> _selectionController = SelectionController(
    domain: LibraryContentProvider.instance.authors.keys.toList(),
    selection: {...widget.inSelectedIds},
  );
  final ScrollController _searchScrollController = ScrollController();

  @override
  void didUpdateWidget(covariant AuthorsSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectionController.addToSelection({...widget.inSelectedIds});
  }

  @override
  void dispose() {
    // Get rid of controllers.
    _selectionController.dispose();
    _searchScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultipleSelectionWidget(
      title: strings.bookInfoAuthors,
      selectionController: _selectionController,
      searchScrollController: _searchScrollController,
      onInsertNewRequested: widget.insertNew
          ? () async {
              final Author? newAuthor = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditAuthorScreen(),
                ),
              );

              if (newAuthor == null) return;

              _selectionController.addToDomain(newAuthor.id, select: true);
            }
          : null,
      onItemsSelected: widget.onAuthorsSelected,
      onItemUnselected: widget.onAuthorUnselected,
      listItemsFilter: (int? authorId, String? filter) => filter != null ? LibraryContentProvider.instance.authors[authorId].toString().toLowerCase().contains(filter) : true,
      listItemBuilder: (int? authorId) {
        final Author? author = LibraryContentProvider.instance.authors[authorId];

        if (author == null) return Placeholder();

        return AuthorLabelWidget(author: author);
      },
      // Reset input selection on selection canceled.
      onSelectionCanceled: () => _selectionController.setSelection({...widget.inSelectedIds}),
    );
  }
}
