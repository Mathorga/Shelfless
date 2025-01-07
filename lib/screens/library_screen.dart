import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/library.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/authors_overview_widget.dart';
import 'package:shelfless/widgets/genres_overview_widget.dart';
import 'package:shelfless/widgets/books_overview_widget.dart';
import 'package:shelfless/widgets/locations_overview_widget.dart';
import 'package:shelfless/widgets/publishers_overview_widget.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = "/library";
  final Library library;

  const LibraryScreen({
    Key? key,
    required this.library,
  }) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _currentIndex = 0;
  String _searchValue = "";

  @override
  Widget build(BuildContext context) {
    LibrariesProvider librariesProvider = Provider.of(context, listen: true);
    final EdgeInsets screenPadding = MediaQuery.paddingOf(context);
    final ThemeData theme = Theme.of(context);

    // Define all pages.
    List<Widget> _pages = [
      BooksOverviewWidget(searchValue: _searchValue),
      GenresOverviewWidget(searchValue: _searchValue),
      AuthorsOverviewWidget(searchValue: _searchValue),
      PublishersOverviewWidget(searchValue: _searchValue),
      LocationsOverviewWidget(searchValue: _searchValue),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.library.name,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline_rounded),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Themes.spacingMedium),
        child: Column(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0.0,
              margin: const EdgeInsets.all(0.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ShelflessColors.glyderDark,
                      ShelflessColors.glyderLight,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Themes.spacingLarge),
                  child: Column(
                    spacing: Themes.spacingMedium,
                    children: [
                      SingleChildScrollView(
                        physics: Themes.scrollPhysics,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: Themes.spacingXLarge,
                          children: [
                            Card(
                              color: ShelflessColors.secondary,
                              child: Padding(
                                padding: const EdgeInsets.all(Themes.spacingSmall),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(
                                      "Favorites",
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: ShelflessColors.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(Themes.spacingSmall),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(
                                      "Highlights",
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: ShelflessColors.secondary,
                              child: Padding(
                                padding: const EdgeInsets.all(Themes.spacingSmall),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(
                                      "Favorites",
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: ShelflessColors.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(Themes.spacingSmall),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(
                                      "Highlights",
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: ShelflessColors.secondary,
                              child: Padding(
                                padding: const EdgeInsets.all(Themes.spacingSmall),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.favorite_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(
                                      "Favorites",
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              color: ShelflessColors.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(Themes.spacingSmall),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(
                                      "Highlights",
                                      style: theme.textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: ShelflessColors.onMainBackgroundInactive,
                        thickness: 2.0,
                        height: Themes.spacingSmall,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: Themes.spacingMedium,
                              children: [
                                Row(
                                  spacing: Themes.spacingMedium,
                                  children: [
                                    Icon(Icons.book_rounded),
                                    Text("${widget.library.books.length}"),
                                  ],
                                ),
                                Row(
                                  spacing: Themes.spacingMedium,
                                  children: [
                                    Icon(Icons.edit_rounded),
                                    Text("${widget.library.books.length}"),
                                  ],
                                ),
                                Row(
                                  spacing: Themes.spacingMedium,
                                  children: [
                                    Icon(Icons.color_lens_rounded),
                                    Text("${widget.library.books.length}"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Icon(Icons.search_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: _pages[_currentIndex],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
