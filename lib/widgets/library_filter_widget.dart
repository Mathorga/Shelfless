import 'package:flutter/material.dart';

import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/widgets/authors_selection_widget.dart';
import 'package:shelfless/widgets/genres_selection_widget.dart';
import 'package:shelfless/widgets/publishers_selection_widget.dart';

class LibraryFilterWidget extends StatelessWidget {
  const LibraryFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Themes.spacingLarge),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: Themes.spacingLarge,
              children: [
                // Title.
                Text(
                  "Filters",
                  style: theme.textTheme.headlineSmall,
                ),

                SearchBar(
                  leading: const Icon(Icons.search_rounded),
                  onChanged: (String value) {
                    // TODO Save the query string for filtering.
                  },
                ),

                // Authors selection.
                StatefulBuilder(builder: (BuildContext context, void Function(void Function()) setState) {
                  LibraryContentProvider.instance.addListener(() => setState(() {}));

                  return AuthorsSelectionWidget(
                    inSelectedIds: LibraryContentProvider.instance.authorsFilter.toList(),
                    onAuthorsSelected: LibraryContentProvider.instance.addAuthorsFilter,
                    onAuthorUnselected: LibraryContentProvider.instance.removeAuthorsFilter,
                  );
                }),

                // Genres selection.
                GenresSelectionWidget(
                  inSelectedIds: LibraryContentProvider.instance.genresFilter.toList(),
                ),

                // Publishers selection.
                PublishersSelectionWidget(
                  inSelectedIds: LibraryContentProvider.instance.publishersFilter.toList(),
                ),

                // FAB spacing.
                SizedBox(
                  height: Themes.spacingFAB,
                )
              ],
            ),
          ),

          // Apply button.
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              onPressed: () {
                final NavigatorState navigator = Navigator.of(context);

                navigator.pop();
              },
              label: Text("Apply"),
              icon: Icon(Icons.check_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
