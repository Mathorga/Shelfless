import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/screens/authors_overview_screen.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';
import 'package:shelfless/widgets/library_filter_widget.dart';

class LibraryContentScreen extends StatefulWidget {
  static const String routeName = "/library";
  final LibraryPreview library;

  const LibraryContentScreen({
    super.key,
    required this.library,
  });

  @override
  State<LibraryContentScreen> createState() => _LibraryContentScreenState();
}

class _LibraryContentScreenState extends State<LibraryContentScreen> {
  @override
  void initState() {
    super.initState();

    // Start listening to changes in library content.
    LibraryContentProvider.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool filtersActive = LibraryContentProvider.instance.getFilters().isActive;

    return PopScope(
      onPopInvokedWithResult: (bool didPop, Object? result) {
        LibraryContentProvider.instance.clear();
      },
      child: Scaffold(
        body: CustomScrollView(
          physics: Themes.scrollPhysics,
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: true,
              shadowColor: Colors.transparent,
              title: Text(
                widget.library.raw.name,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    filtersActive ? Icons.filter_alt : Icons.filter_alt_outlined,
                    color: filtersActive ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                  ),
                  onPressed: () {
                    showBarModalBottomSheet(
                      context: context,
                      enableDrag: true,
                      expand: false,
                      backgroundColor: theme.colorScheme.surface,
                      builder: (BuildContext context) => LibraryFilterWidget(),
                    );
                  },
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => BookPreviewWidget(
                  book: LibraryContentProvider.instance.books[index],
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (BuildContext context) => BookInfoScreen(
                  //     book: _filteredBooks[index],
                  //   ),
                  // )),
                ),
                childCount: LibraryContentProvider.instance.books.length,
              ),
            ),
          ],
        ),
        floatingActionButton: filtersActive
            ? null
            : FloatingActionButton(
                onPressed: () {
                  final NavigatorState navigator = Navigator.of(context);

                  // TODO Navigate to EditBookScreen
                  navigator.push(MaterialPageRoute(builder: (BuildContext context) => EditBookScreen()));
                },
                child: Icon(Icons.add_rounded),
              ),
      ),
    );
  }

  Widget _buildActionBar() {
    return Padding(
      padding: const EdgeInsets.all(Themes.spacingLarge),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: Themes.spacingXLarge,
              children: [
                // Authors.
                InkWell(
                  onTap: () {
                    final NavigatorState navigator = Navigator.of(context);

                    navigator.push(MaterialPageRoute(
                      builder: (BuildContext context) => AuthorsOverviewScreen(),
                    ));
                  },
                  child: Icon(Icons.person_pin_rounded),
                ),

                // Genres.
                InkWell(
                  onTap: () {},
                  child: Icon(Icons.color_lens_rounded),
                ),

                // Publishers.
                InkWell(
                  child: Icon(Icons.work_rounded),
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
    );
  }

  Widget _buildCollectionPreviews() {
    final ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
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
    );
  }
}
