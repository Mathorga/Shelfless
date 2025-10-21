import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/genre_label_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/selection_widget/multiple_selection_widget.dart';

class GenresSelectionWidget extends StatefulWidget {
  /// Already selected genre ids.
  final Set<int?> initialSelection;

  /// Whether the widget should allow the user to add a new genre if not present already.
  final bool insertNew;

  /// Called when a new set of genres is selected from the source list,
  final void Function(Set<int?> genreIds)? onGenresSelected;

  /// Called when a genre is removed from the selection list.
  final void Function(int genreId)? onGenreUnselected;

  const GenresSelectionWidget({
    super.key,
    this.initialSelection = const {},
    this.insertNew = false,
    this.onGenresSelected,
    this.onGenreUnselected,
  });

  @override
  State<GenresSelectionWidget> createState() => _GenresSelectionWidgetState();
}

class _GenresSelectionWidgetState extends State<GenresSelectionWidget> {
  late final SelectionController<int?> _selectionController = SelectionController(
    domain: LibraryContentProvider.instance.genres.keys.toList(),
    selection: {...widget.initialSelection},
  );
  final ScrollController _searchScrollController = ScrollController();

  @override
  void didUpdateWidget(covariant GenresSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectionController.addToSelection({...widget.initialSelection});
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
      title: strings.bookInfoGenres,
      selectionController: _selectionController,
      searchScrollController: _searchScrollController,
      initialSelection: widget.initialSelection,
      onInsertNewRequested: widget.insertNew
          ? () async {
              final RawGenre? newGenre = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditGenreScreen(),
                ),
              );

              if (newGenre == null) return;

              _selectionController.addToDomain(newGenre.id, select: true);
            }
          : null,
      onItemsSelected: widget.onGenresSelected,
      onItemUnselected: widget.onGenreUnselected,
      listItemsFilter: (int? genreId, String? filter) => filter != null ? LibraryContentProvider.instance.genres[genreId].toString().toLowerCase().contains(filter) : true,
      listItemBuilder: (int? genreId) {
        final RawGenre? rawGenre = LibraryContentProvider.instance.genres[genreId];

        if (rawGenre == null) return Placeholder();

        return GenreLabelWidget(genre: rawGenre);
      },
      // Reset input selection on selection canceled.
      onSelectionCanceled: () => _selectionController.setSelection({...widget.initialSelection}),
    );
  }
}
