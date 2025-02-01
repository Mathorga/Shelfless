import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/book_detail_screen.dart';
import 'package:shelfless/screens/edit_book_screen.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/screens/authors_overview_screen.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/book_preview_widget.dart';
import 'package:shelfless/screens/genres_overview_screen.dart';
import 'package:shelfless/widgets/libraries_list_widget.dart';
import 'package:shelfless/widgets/library_filter_widget.dart';
import 'package:shelfless/widgets/unreleased_feature_dialog.dart';

enum LibraryAction {
  edit,
  displayMode,
  share,
}

class LibraryContentScreen extends StatefulWidget {
  final LibraryPreview? library;

  const LibraryContentScreen({
    super.key,
    this.library,
  });

  @override
  State<LibraryContentScreen> createState() => _LibraryContentScreenState();
}

class _LibraryContentScreenState extends State<LibraryContentScreen> {
  LibraryPreview? library;

  @override
  void initState() {
    super.initState();

    library = widget.library;

    // Start listening to changes in library content.
    LibraryContentProvider.instance.addListener(() => setState(() {
          if (LibraryContentProvider.instance.library != null) library = LibraryPreview(raw: LibraryContentProvider.instance.library!);
        }));

    if (library != null) LibraryContentProvider.instance.fetchLibraryContent(library!.raw);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool filtersActive = LibraryContentProvider.instance.getFilters().isActive;
    final Size screenSize = MediaQuery.sizeOf(context);
    final EdgeInsets screenPadding = MediaQuery.paddingOf(context);
    final double crossAxisSpacing = 0.0;
    final double itemHeight = 280.0;
    final double leftRightPadding = 0.0;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          spacing: Themes.spacingSmall,
          children: [
            // Top padding.
            SizedBox(
              height: screenPadding.top,
            ),

            // App name.
            Text(
              Themes.appName,
              style: theme.textTheme.headlineMedium,
            ),

            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Themes.spacingSmall),
                child: Column(
                  children: [
                    // Libraries list.
                    LibrariesListWidget(),

                    Divider(),

                    // Authors.
                    _buildLibraryEntry(
                      // label: strings.authorsSectionTitle,
                      onPressed: () {
                        final NavigatorState navigator = Navigator.of(context);

                        navigator.push(MaterialPageRoute(
                          builder: (BuildContext context) => AuthorsOverviewScreen(),
                        ));
                      },
                      child: Row(
                        spacing: Themes.spacingMedium,
                        children: [
                          Icon(
                            Icons.person_pin_rounded,
                            size: Themes.iconSizeLarge,
                          ),
                          Text(strings.authorsSectionTitle),
                        ],
                      ),
                    ),

                    // Genres.
                    _buildLibraryEntry(
                      onPressed: () {
                        final NavigatorState navigator = Navigator.of(context);

                        navigator.push(MaterialPageRoute(
                          builder: (BuildContext context) => GenresOverviewScreen(),
                        ));
                      },
                      child: Row(
                        spacing: Themes.spacingMedium,
                        children: [
                          Icon(
                            Icons.color_lens_rounded,
                            size: Themes.iconSizeLarge,
                          ),
                          Text(strings.genresSectionTitle),
                        ],
                      ),
                    ),

                    // Publishers.
                    Opacity(
                      opacity: Themes.unavailableFeatureOpacity,
                      child: _buildLibraryEntry(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => UnreleasedFeatureDialog(),
                          );
                        },
                        child: Row(
                          spacing: Themes.spacingMedium,
                          children: [
                            Icon(
                              Icons.work_rounded,
                              size: Themes.iconSizeLarge,
                            ),
                            Text(strings.publishersSectionTitle),
                          ],
                        ),
                      ),
                    ),

                    // Locations.
                    Opacity(
                      opacity: Themes.unavailableFeatureOpacity,
                      child: _buildLibraryEntry(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => UnreleasedFeatureDialog(),
                          );
                        },
                        child: Row(
                          spacing: Themes.spacingMedium,
                          children: [
                            Icon(
                              Icons.place_rounded,
                              size: Themes.iconSizeLarge,
                            ),
                            Text(strings.locationsSectionTitle),
                          ],
                        ),
                      ),
                    ),

                    Divider(),

                    // TODO Add all user-defined collections if present.
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: library != null
          ? CustomScrollView(
              physics: Themes.scrollPhysics,
              slivers: [
                SliverAppBar(
                  pinned: false,
                  snap: false,
                  floating: true,
                  shadowColor: Colors.transparent,
                  title: Text(
                    library!.raw.name,
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
                    PopupMenuButton<LibraryAction>(
                      itemBuilder: (BuildContext context) {
                        return [
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
                          PopupMenuItem(
                            value: LibraryAction.displayMode,
                            enabled: false,
                            child: Row(
                              spacing: Themes.spacingSmall,
                              children: [
                                const Icon(Icons.view_list_rounded),
                                Text("Show list"),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: LibraryAction.share,
                            child: Row(
                              spacing: Themes.spacingSmall,
                              children: [
                                const Icon(Icons.share_rounded),
                                Text(strings.shareLibrary),
                              ],
                            ),
                          ),
                        ];
                      },
                      onSelected: (LibraryAction value) async {
                        final NavigatorState navigator = Navigator.of(context);

                        switch (value) {
                          case LibraryAction.edit:
                            navigator.push(MaterialPageRoute(builder: (BuildContext context) {
                              return EditLibraryScreen(
                                library: library,
                                onDone: () => navigator.pop(),
                              );
                            }));
                            break;
                          case LibraryAction.displayMode:
                            break;
                          case LibraryAction.share:
                            if (library!.raw.id == null) return;

                            // Extract the library.
                            final Map<String, String> libraryStrings = await DatabaseHelper.instance.extractLibrary(library!.raw.id!);

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
                                "${library!.raw.name}.slz",
                              ],
                            );
                            break;
                        }
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
                      final Book book = LibraryContentProvider.instance.books[index];
                      return BookPreviewWidget(
                        book: book,
                        onTap: () {
                          // Prefetch handlers before async gaps.
                          final NavigatorState navigator = Navigator.of(context);

                          // Navigate to book edit screen.
                          navigator.push(MaterialPageRoute(
                            builder: (BuildContext context) => BookDetailScreen(
                              book: book,
                            ),
                          ));
                        },
                      );
                    },
                    childCount: LibraryContentProvider.instance.books.length,
                  ),
                ),

                // Space left for the FAB.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(Themes.spacingMedium),
                    child: SizedBox(
                      height: Themes.spacingFAB,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text("No libraries"),
            ),
      floatingActionButton: filtersActive
          ? null
          : FloatingActionButton(
              onPressed: () {
                final NavigatorState navigator = Navigator.of(context);

                // Navigate to EditBookScreen
                navigator.push(MaterialPageRoute(builder: (BuildContext context) => EditBookScreen()));
              },
              child: Icon(Icons.add_rounded),
            ),
    );
  }

  Widget _buildLibraryEntry({
    required Widget child,
    void Function()? onPressed,
  }) {
    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
