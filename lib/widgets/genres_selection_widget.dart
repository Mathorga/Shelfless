
import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/genre_preview_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

class GenresSelectionWidget extends StatelessWidget {
  final List<int?> genreIds;
  final void Function(Set<int?> genreId)? onGenresAdded;
  final void Function(int genreId)? onGenreRemoved;

  GenresSelectionWidget({
    super.key,
    List<int?>? inGenreIds,
    this.onGenresAdded,
    this.onGenreRemoved,
  }) : genreIds = inGenreIds ?? [];

  @override
  Widget build(BuildContext context) {
    return EditSectionWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.bookInfoGenres),
            DialogButtonWidget(
              label: const Icon(Icons.add_rounded),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(strings.bookInfoGenres),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EditGenreScreen(),
                      ));
                    },
                    child: Text(strings.add),
                  ),
                ],
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  // Make sure updates are reacted to.
                  LibraryContentProvider.instance.addListener(() {
                    if (context.mounted) setState(() {});
                  });

                  return SearchListWidget<int?>(
                    children: LibraryContentProvider.instance.genres.keys.toList(),
                    multiple: true,
                    filter: (int? genreId, String? filter) => filter != null ? LibraryContentProvider.instance.genres[genreId].toString().toLowerCase().contains(filter) : true,
                    builder: (int? genreId) {
                      final RawGenre? rawGenre = LibraryContentProvider.instance.genres[genreId];

                      if (rawGenre == null) {
                        return Placeholder();
                      }

                      return GenrePreviewWidget(genre: rawGenre);
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onElementsSelected: (Set<int?> selectedGenreIds) {
                      final NavigatorState navigator = Navigator.of(context);

                      onGenresAdded?.call(selectedGenreIds);

                      navigator.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (genreIds.isNotEmpty)
          Column(
            children: [
              Themes.spacer,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: genreIds.map((int? genreId) => _buildGenrePreview(genreId)).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildGenrePreview(int? genreId) {
    if (genreId == null) return Placeholder();

    final RawGenre? rawGenre = LibraryContentProvider.instance.genres[genreId];

    if (rawGenre == null) return Placeholder();

    return _buildPreview(
      GenrePreviewWidget(genre: rawGenre),
      onDelete: () {
        onGenreRemoved?.call(genreId);
      },
    );
  }

  Widget _buildPreview(Widget child, {void Function()? onDelete}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: child,
        ),
        TextButton(
          onPressed: () {
            onDelete?.call();
          },
          child: Icon(
            Icons.close_rounded,
            color: ShelflessColors.error,
          ),
        ),
      ],
    );
  }
}