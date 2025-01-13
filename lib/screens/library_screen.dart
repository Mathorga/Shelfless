import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shelfless/models/library.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/library_content_provider.dart';

import 'package:shelfless/screens/books_filter_screen.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/screens/authors_overview_screen.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';
import 'package:shelfless/widgets/genres_overview_widget.dart';
import 'package:shelfless/widgets/locations_overview_widget.dart';
import 'package:shelfless/widgets/publishers_overview_widget.dart';
import 'package:shelfless/widgets/separator_widget.dart';

class LibraryScreen extends StatefulWidget {
  static const String routeName = "/library";
  final LibraryPreview library;

  const LibraryScreen({
    super.key,
    required this.library,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _currentIndex = 0;
  String _searchValue = "";

  @override
  void initState() {
    super.initState();

    // Start listening to changes in library content.
    LibraryContentProvider.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
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
                icon: Icon(Icons.filter_alt_outlined),
                onPressed: () {},
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final NavigatorState navigator = Navigator.of(context);

          // TODO Navigate to EditBookScreen
          navigator.push(MaterialPageRoute(builder: (BuildContext context) => EditBookScreen()));
        },
        child: Icon(Icons.add_rounded),
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
