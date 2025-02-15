import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/providers/library_filters_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/authors_selection_widget.dart';
import 'package:shelfless/widgets/genres_selection_widget.dart';
import 'package:shelfless/widgets/locations_selection_widget.dart';
import 'package:shelfless/widgets/publishers_selection_widget.dart';

class LibraryFilterWidget extends StatefulWidget {
  const LibraryFilterWidget({super.key});

  @override
  State<LibraryFilterWidget> createState() => _LibraryFilterWidgetState();
}

class _LibraryFilterWidgetState extends State<LibraryFilterWidget> {
  // Start off from any already-present filter.
  final LibraryFilters _filters = LibraryContentProvider.instance.getFilters().copy();

  final TextEditingController _titleFilterController = TextEditingController(text: LibraryContentProvider.instance.getFilters().titleFilter);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size screenSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.all(Themes.spacingLarge),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: Themes.spacingMedium,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              physics: Themes.scrollPhysics,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: Themes.spacingLarge,
                children: [
                  // Title.
                  Text(
                    strings.filtersTitle,
                    style: theme.textTheme.headlineSmall,
                  ),

                  // Search bar.
                  SizedBox(
                    width: min(screenSize.width, Themes.maxContentWidth),
                    child: SearchBar(
                      leading: const Icon(Icons.search_rounded),
                      controller: _titleFilterController,
                      onChanged: (String value) {
                        // Save the query string for filtering.
                        setState(() {
                          _filters.titleFilter = value;
                        });
                      },
                    ),
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

                  // Locations selection.
                  LocationsSelectionWidget(
                    inSelectedIds: _filters.locationsFilter.toList(),
                    onLocationsSelected: (Set<int?> selectedLocationIds) {
                      setState(() {
                        _filters.locationsFilter.addAll(selectedLocationIds);
                      });
                    },
                    onLocationUnselected: (int? unselectedLocationId) {
                      setState(() {
                        _filters.locationsFilter.remove(unselectedLocationId);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),

          // Apply button.
          Row(
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
        ],
      ),
    );
  }
}
