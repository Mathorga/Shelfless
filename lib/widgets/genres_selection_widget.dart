import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/genre_label_widget.dart';
import 'package:shelfless/widgets/selection_widget/selection_controller.dart';
import 'package:shelfless/widgets/selection_widget/multiple_selection_widget.dart';

class GenresSelectionWidget extends StatefulWidget {
  /// Already selected genre ids.
  final List<int?> inSelectedIds;

  /// Whether the widget should allow the user to add a new genre if not present already.
  final bool insertNew;

  /// Called when a new set of genres is selected from the source list,
  final void Function(Set<int?> genreIds)? onGenresSelected;

  /// Called when a genre is removed from the selection list.
  final void Function(int genreId)? onGenreUnselected;

  const GenresSelectionWidget({
    super.key,
    this.inSelectedIds = const [],
    this.insertNew = false,
    this.onGenresSelected,
    this.onGenreUnselected,
  });

  @override
  State<GenresSelectionWidget> createState() => _GenresSelectionWidgetState();
}

class _GenresSelectionWidgetState extends State<GenresSelectionWidget> {
  late final SelectionController _selectionController = SelectionController(
    sourceIds: LibraryContentProvider.instance.genres.keys.toList(),
    selectedIds: {...widget.inSelectedIds},
  );

  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      _selectionController.setSourceIds(LibraryContentProvider.instance.genres.keys.toList());
    });
  }

  @override
  void didUpdateWidget(covariant GenresSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectionController.addSelection({...widget.inSelectedIds});
  }

  @override
  Widget build(BuildContext context) {
    return MultipleSelectionWidget(
      title: strings.bookInfoGenres,
      controller: _selectionController,
      onInsertNewRequested: widget.insertNew
          ? () async {
              final RawGenre? newGenre = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditGenreScreen(),
                ),
              );

              if (newGenre == null) return;

              _selectionController.addSourceId(newGenre.id, select: true);
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
    );
  }
}