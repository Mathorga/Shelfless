import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/screens/authors_overview_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
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
    final Size screenSize = MediaQuery.sizeOf(context);
    final double crossAxisSpacing = Themes.spacingSmall;
    final double itemHeight = 300.0;
    final double leftRightPadding = 0.0;

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
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: crossAxisSpacing,
                childAspectRatio: ((screenSize.width - (leftRightPadding + crossAxisSpacing)) / 2) / itemHeight,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  // Since the first entry is used for the action bar, the actual book index is 1 less than the provided one.
                  final int bookIndex = index - 1;

                  return index == 0
                      ? _buildActionBar()
                      : BookPreviewWidget(
                          book: LibraryContentProvider.instance.books[bookIndex],
                          onTap: () {
                            // Prefetch handlers before async gaps.
                            final NavigatorState navigator = Navigator.of(context);

                            // Navigate to book edit screen.
                            navigator.push(MaterialPageRoute(
                              builder: (BuildContext context) => EditBookScreen(
                                book: LibraryContentProvider.instance.books[bookIndex],
                              ),
                            ));
                          },
                        );
                },
                childCount: LibraryContentProvider.instance.books.length + 1,
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: Themes.spacingXLarge,
          children: [
            // Authors.
            _buildAction(
              label: strings.authorsSectionTitle,
              onPressed: () {
                final NavigatorState navigator = Navigator.of(context);

                navigator.push(MaterialPageRoute(
                  builder: (BuildContext context) => AuthorsOverviewScreen(),
                ));
              },
              child: Icon(
                Icons.person_pin_rounded,
                size: Themes.iconSizeMedium,
              ),
            ),

            // Genres.
            _buildAction(
              label: strings.genresSectionTitle,
              onPressed: () {},
              child: Icon(
                Icons.color_lens_rounded,
                size: Themes.iconSizeMedium,
              ),
            ),

            // Publishers.
            _buildAction(
              label: strings.publishersSectionTitle,
              onPressed: () {},
              child: Icon(
                Icons.work_rounded,
                size: Themes.iconSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction({
    required String label,
    required Widget child,
    void Function()? onPressed,
  }) {
    return SizedBox(
      width: Themes.actionSize,
      child: Column(
        spacing: Themes.spacingSmall,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ShelflessColors.secondary,
              iconColor: ShelflessColors.onMainBackgroundInactive,
            ),
            onPressed: onPressed,
            child: child,
          ),
          Text(label),
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
