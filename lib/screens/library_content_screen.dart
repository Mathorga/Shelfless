import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:archive/archive.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/books_detail_screen.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/utils/view_mode.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';
import 'package:shelfless/dialogs/delete_dialog.dart';
import 'package:shelfless/widgets/drawer_content_widget.dart';
import 'package:shelfless/widgets/library_filter_widget.dart';
import 'package:shelfless/widgets/library_sort_order_list_widget.dart';

enum LibraryAction {
  filter,
  toggleViewMode,
  sortBy,
  edit,
  delete,
  share,
}

class LibraryContentScreen extends StatefulWidget {
  final LibraryPreview? library;

  const LibraryContentScreen({
    super.key,
    required this.library,
  });

  @override
  State<LibraryContentScreen> createState() => _LibraryContentScreenState();
}

class _LibraryContentScreenState extends State<LibraryContentScreen> {
  late LibraryPreview? library;

  ViewMode viewMode = ViewMode.extendedGrid;

  @override
  void initState() {
    super.initState();

    library = widget.library;

    // Try and read viewmode from shared preferences.
    _readViewMode();

    // Start listening to changes in shared preferences.
    SharedPrefsHelper.instance.addListener(_onSharedPrefUpdated);

    // Start listening to changes in library content.
    LibraryContentProvider.instance.addListener(_onLibraryContentUpdated);

    LibraryContentProvider.instance.openLibrary(rawLibrary: library?.raw);
  }

  void _onSharedPrefUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onLibraryContentUpdated() {
    if (mounted) {
      // Here setState must be called regardless of the internal state, otherwise changes will be noticed only on library change.
      setState(() {
        final RawLibrary? providerLibrary = LibraryContentProvider.instance.library;

        if (providerLibrary == null) {
          library = null;
        } else {
          // Make sure the provider's library is not null and it's not the one the user's already seeing.
          if (library?.raw != providerLibrary) {
            library = LibraryPreview(
              raw: providerLibrary,
            );
          }
        }
      });
    }
  }

  void _readViewMode() async {
    final int? storedId = (await SharedPreferences.getInstance()).getInt(SharedPrefsKeys.viewMode);

    if (storedId != null) setState(() => viewMode = ViewMode.values[storedId]);
  }

  @override
  void dispose() {
    // Remove listeners.
    LibraryContentProvider.instance.removeListener(_onSharedPrefUpdated);
    SharedPrefsHelper.instance.removeListener(_onLibraryContentUpdated);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool filtersActive = LibraryContentProvider.instance.getFilters().isActive;
    final Size screenSize = MediaQuery.sizeOf(context);
    final EdgeInsets devicePadding = MediaQuery.paddingOf(context);
    final double crossAxisSpacing = Themes.spacingSmall;
    final double mainAxisSpacing = Themes.spacingSmall;
    final double wideItemWidth = 200.0;
    final double thinItemWidth = 100.0;
    final double wideItemHeight = 280.0;
    final double thinItemHeight = 100.0;
    final double leftRightPadding = Themes.spacingSmall;

    final double itemWidth = switch (viewMode) {
      ViewMode.extendedGrid => wideItemWidth,
      ViewMode.compactGrid => thinItemWidth,
      ViewMode.list => thinItemWidth,
    };

    final double itemHeight = switch (viewMode) {
      ViewMode.extendedGrid => wideItemHeight,
      ViewMode.compactGrid => thinItemHeight,
      ViewMode.list => thinItemHeight,
    };

    // The cross axis count should never go below 2.
    final int gridCrossAxisCount = switch (viewMode) {
      ViewMode.extendedGrid => max((screenSize.width / itemWidth).toInt(), 2),
      ViewMode.compactGrid => max((screenSize.width / itemWidth).toInt(), 3),
      ViewMode.list => max((screenSize.width / itemWidth).toInt(), 2),
    };

    // Save books locally for easier (not faster) access.
    final List<Book> books = LibraryContentProvider.instance.books;

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(child: DrawerContentWidget()),
      ),
      body: SafeArea(
        child: CustomScrollView(
          // Make sure no scrolling is allowed when no books are available.
          physics: books.isEmpty ? NeverScrollableScrollPhysics() : Themes.scrollPhysics,
          slivers: [
            SliverAppBar(
              pinned: false,
              snap: false,
              floating: true,
              shadowColor: Colors.transparent,
              title: Text(
                library?.raw.name ?? strings.all,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                // Filters action.
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

                // View mode change action.
                IconButton(
                  onPressed: () async {
                    setState(() {
                      // Rotate ViewMode values.
                      viewMode = ViewMode.values[(viewMode.index + 1) % ViewMode.values.length];
                    });

                    // Store viewmode in shared preferences.
                    (await SharedPreferences.getInstance()).setInt(SharedPrefsKeys.viewMode, viewMode.index);
                  },
                  icon: Icon(
                    switch (viewMode) {
                      ViewMode.list => Icons.table_rows_rounded,
                      ViewMode.compactGrid => Icons.view_module_rounded,
                      ViewMode.extendedGrid => Icons.grid_view_rounded,
                    },
                  ),
                ),

                // More actions.
                PopupMenuButton<LibraryAction>(
                  icon: Icon(Icons.more_vert_rounded),
                  itemBuilder: (BuildContext context) {
                    return [
                      // Sort order button.
                      PopupMenuItem(
                        value: LibraryAction.sortBy,
                        child: Row(
                          spacing: Themes.spacingSmall,
                          children: [
                            const Icon(Icons.sort_rounded),
                            Text(strings.librarySortBy),
                          ],
                        ),
                      ),

                      // Library-related actions.
                      if (LibraryContentProvider.instance.editable) ...[
                        // Edit button.
                        PopupMenuItem(
                          value: LibraryAction.edit,
                          child: Row(
                            spacing: Themes.spacingSmall,
                            children: [
                              const Icon(Icons.edit_rounded),
                              Text(strings.editTitle),
                            ],
                          ),
                        ),

                        // Only let the user delete a library if it's not the last one.
                        if (LibrariesProvider.instance.libraries.length > 1)
                          PopupMenuItem(
                            value: LibraryAction.delete,
                            child: Row(
                              spacing: Themes.spacingSmall,
                              children: [
                                const Icon(Icons.delete_rounded),
                                Text(strings.deleteTitle),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: LibraryAction.share,
                          child: Row(
                            spacing: Themes.spacingSmall,
                            children: [
                              const Icon(Icons.share_rounded),
                              Text(strings.libraryShare),
                            ],
                          ),
                        ),
                      ],
                    ];
                  },
                  onSelected: (LibraryAction value) async {
                    final NavigatorState navigator = Navigator.of(context);

                    switch (value) {
                      case LibraryAction.sortBy:
                        showBarModalBottomSheet(
                          context: context,
                          enableDrag: true,
                          expand: false,
                          backgroundColor: theme.colorScheme.surface,
                          builder: (BuildContext context) => LibrarySortOrderListWidget(),
                        );
                        break;
                      case LibraryAction.edit:
                        navigator.push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return EditLibraryScreen(
                              library: library,
                              onDone: () => navigator.pop(),
                            );
                          },
                        ));
                        break;
                      case LibraryAction.delete:
                        // Let the user know all contained books will be deleted as well.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => DeleteDialog(
                            titleString: strings.deleteLibraryTitle,
                            contentString: strings.deleteLibraryContent,
                            onConfirm: () async {
                              // Actually delete the library.
                              await LibraryContentProvider.instance.deleteLibrary();
                            },
                          ),
                        );
                        break;
                      case LibraryAction.share:
                        if (library?.raw.id == null) return;

                        // Extract the library.
                        final Map<String, String> libraryStrings = await DatabaseHelper.instance.serializeLibrary(library!.raw.id!);

                        // Compress the library files to a single .slz file.
                        final Archive archive = Archive();
                        libraryStrings.entries
                            .map((MapEntry<String, String> element) => ArchiveFile(
                                  "${element.key}.json",
                                  element.value.length,
                                  element.value.codeUnits,
                                ))
                            .forEach((ArchiveFile file) => archive.addFile(file));
                        final Uint8List encodedArchive = ZipEncoder().encodeBytes(archive);

                        // Share the library to other apps.
                        Share.shareXFiles(
                          [
                            XFile.fromData(
                              encodedArchive,
                              length: encodedArchive.length,
                              mimeType: "application/x-zip",
                            ),
                          ],
                          // The name parameter in the XFile.fromData method is ignored in most platforms,
                          // so fileNameOverrides is used instead.
                          fileNameOverrides: [
                            "${library!.raw.name}.$libraryFileFormat",
                          ],
                        );
                        break;
                      default:
                        break;
                    }
                  },
                ),
              ],
            ),

            if (books.isNotEmpty)
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: leftRightPadding),
                sliver: viewMode == ViewMode.list
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final Book book = books[index];
                            return BookPreviewWidget(
                              book: book,
                              viewMode: viewMode,
                              onTap: () => _gotoBookDetails(book),
                            );
                          },
                          childCount: books.length,
                        ),
                      )
                    : SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCrossAxisCount,
                          crossAxisSpacing: crossAxisSpacing,
                          mainAxisSpacing: mainAxisSpacing,
                          // TODO Can do better on iPhone.
                          childAspectRatio: ((screenSize.width - (leftRightPadding + crossAxisSpacing)) / gridCrossAxisCount) / itemHeight,
                          // childAspectRatio: itemWidth / itemHeight,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final Book book = books[index];
                            return switch (viewMode) {
                              ViewMode.extendedGrid => BookPreviewWidget(
                                  book: book,
                                  viewMode: viewMode,
                                  onTap: () => _gotoBookDetails(book),
                                ),
                              ViewMode.compactGrid => BookPreviewWidget(
                                  book: book,
                                  viewMode: viewMode,
                                  onTap: () => _gotoBookDetails(book),
                                ),
                              ViewMode.list => Placeholder(),
                            };
                          },
                          childCount: books.length,
                        ),
                      ),
              ),

            if (books.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(strings.noBooksFound),
                ),
              ),

            // Space left for the FAB.
            SliverToBoxAdapter(
              // TODO Check whether adding the device botto inset also works on Android, since it's designed for iOS.
              child: SizedBox(
                height: fabAccessHeight + devicePadding.bottom,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: LibraryContentProvider.instance.editable
          ? FloatingActionButton(
              onPressed: () {
                final NavigatorState navigator = Navigator.of(context);

                // Navigate to EditBookScreen
                navigator.push(MaterialPageRoute(builder: (BuildContext context) => EditBookScreen()));
              },
              child: Icon(Icons.add_rounded),
            )
          : null,
    );
  }

  void _gotoBookDetails(Book book) {
    // Navigate to book edit screen.
    context.pushTransparentRoute(
      BooksDetailScreen(openingBook: book),
    );
  }
}
