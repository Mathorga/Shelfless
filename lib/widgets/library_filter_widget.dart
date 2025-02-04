import 'package:flutter/material.dart';

import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/providers/library_filters_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/authors_selection_widget.dart';
import 'package:shelfless/widgets/genres_selection_widget.dart';
import 'package:shelfless/widgets/publishers_selection_widget.dart';

class LibraryFilterWidget extends StatefulWidget {
  const LibraryFilterWidget({super.key});

  @override
  State<LibraryFilterWidget> createState() => _LibraryFilterWidgetState();
}

class _LibraryFilterWidgetState extends State<LibraryFilterWidget> {
  // Start off from any already-present filter.
  final LibraryFilters _filters = LibraryContentProvider.instance.getFilters().copy();

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
                  strings.filtersTitle,
                  style: theme.textTheme.headlineSmall,
                ),

                SearchBar(
                  leading: const Icon(Icons.search_rounded),
                  onChanged: (String value) {
                    // Save the query string for filtering.
                    setState(() {
                      _filters.titleFilter = value;
                    });
                  },
                ),

                // Authors selection.
                AuthorsSelectionWidget(
                  inSelectedIds: _filters.authorsFilter.toList(),
                  onAuthorsSelected: (Set<int?> selectedAuthorIds) {
                    setState(() {
                      _filters.authorsFilter.addAll(selectedAuthorIds);
                    });
                  },
                  onAuthorUnselected: (int? unselectedAuthorId) {
                    setState(() {
                      _filters.authorsFilter.remove(unselectedAuthorId);
                    });
                  },
                ),

                // Genres selection.
                GenresSelectionWidget(
                  inSelectedIds: _filters.genresFilter.toList(),
                  onGenresSelected: (Set<int?> selectedGenreIds) {
                    setState(() {
                      _filters.genresFilter.addAll(selectedGenreIds);
                    });
                  },
                  onGenreUnselected: (int? unselectedGenreId) {
                    setState(() {
                      _filters.genresFilter.remove(unselectedGenreId);
                    });
                  },
                ),

                // Publishers selection.
                PublishersSelectionWidget(
                  inSelectedIds: _filters.publishersFilter.toList(),
                  onPublishersSelected: (Set<int?> selectedPublisherIds) {
                    setState(() {
                      _filters.publishersFilter.addAll(selectedPublisherIds);
                    });
                  },
                  onPublisherUnselected: (int? unselectedPublisherId) {
                    setState(() {
                      _filters.publishersFilter.remove(unselectedPublisherId);
                    });
                  },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: Themes.spacingLarge,
              children: [
                if (_filters.isActive)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _filters.clear();
                      });
                    },
                    child: Text(strings.filtersClear),
                  ),
                FloatingActionButton.extended(
                  onPressed: () {
                    final NavigatorState navigator = Navigator.of(context);

                    // Apply user-selected filters.
                    LibraryContentProvider.instance.applyFilters(_filters);

                    navigator.pop();
                  },
                  label: Text(strings.filtersApply),
                  icon: Icon(Icons.check_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
