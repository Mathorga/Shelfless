import 'package:flutter/material.dart';

import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/providers/library_filters_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/authors_selection_widget.dart';
import 'package:shelfless/widgets/genres_selection_widget.dart';
import 'package:shelfless/widgets/publishers_selection_widget.dart';

class LibraryFilterWidget extends StatelessWidget {
  final LibraryFiltersProvider _libraryFiltersProvider = LibraryFiltersProvider(
    inFilters: LibraryContentProvider.instance.getFilters(),
  );

  LibraryFilterWidget({super.key});

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
                    _libraryFiltersProvider.addTitleFilter(value);
                  },
                ),

                // Authors selection.
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    _libraryFiltersProvider.addListener(() => setState(() {}));

                    return AuthorsSelectionWidget(
                      inSelectedIds: _libraryFiltersProvider.filters.authorsFilter.toList(),
                      onAuthorsSelected: _libraryFiltersProvider.addAuthorsFilter,
                      onAuthorUnselected: _libraryFiltersProvider.removeAuthorsFilter,
                    );
                  },
                ),

                // Genres selection.
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    _libraryFiltersProvider.addListener(() => setState(() {}));

                    return GenresSelectionWidget(
                      inSelectedIds: _libraryFiltersProvider.filters.genresFilter.toList(),
                      onGenresSelected: _libraryFiltersProvider.addGenresFilter,
                      onGenreUnselected: _libraryFiltersProvider.removeGenresFilter,
                    );
                  },
                ),

                // Publishers selection.
                StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) setState) {
                    _libraryFiltersProvider.addListener(() => setState(() {}));

                    return PublishersSelectionWidget(
                      inSelectedIds: _libraryFiltersProvider.filters.publishersFilter.toList(),
                      onPublishersSelected: _libraryFiltersProvider.addPublishersFilter,
                      onPublisherUnselected: _libraryFiltersProvider.removePublishersFilter,
                    );
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
            child: StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                _libraryFiltersProvider.addListener(() => setState(() {}));

                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: Themes.spacingLarge,
                  children: [
                    if (_libraryFiltersProvider.filters.isActive)
                      TextButton(
                        onPressed: () {
                          _libraryFiltersProvider.clear();
                        },
                        child: Text(strings.filtersClear),
                      ),
                    FloatingActionButton.extended(
                      onPressed: () {
                        final NavigatorState navigator = Navigator.of(context);

                        // Apply user-selected filters.
                        LibraryContentProvider.instance.applyFilters(_libraryFiltersProvider.filters);

                        navigator.pop();
                      },
                      label: Text(strings.filtersApply),
                      icon: Icon(Icons.check_rounded),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
