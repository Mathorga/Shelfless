import 'package:flutter/material.dart';

import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unavailable_content_widget.dart';
import 'package:shelfless/widgets/unreleased_feature_dialog.dart';

class LibrariesListWidget extends StatefulWidget {
  const LibrariesListWidget({super.key});

  @override
  State<LibrariesListWidget> createState() => _LibrariesListWidgetState();
}

class _LibrariesListWidgetState extends State<LibrariesListWidget> {
  @override
  void initState() {
    super.initState();

    LibrariesProvider.instance.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Libraries list.
        ...List.generate(LibrariesProvider.instance.libraries.length + 2, (int index) {
          // Add library.
          if (index > LibrariesProvider.instance.libraries.length) {
            return _buildLibraryEntry(
              onPressed: () {
                // Show dialog asking the user whether to create a new library or import one.
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(strings.addLibraryTitle),
                        content: Row(
                          spacing: Themes.spacingMedium,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _buildNewLibraryOption(
                                onPressed: () async {
                                  // Prefetch handlers before async gaps.
                                  final NavigatorState navigator = Navigator.of(context);

                                  // Navigate to library creation screen.
                                  await navigator.push(
                                    MaterialPageRoute(
                                      builder: (BuildContext context) => EditLibraryScreen(
                                        onDone: () => navigator.pop(),
                                      ),
                                    ),
                                  );

                                  // Pop dialog.
                                  navigator.pop();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.playlist_add_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(strings.newLib),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: _buildNewLibraryOption(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.download_rounded,
                                      size: Themes.iconSizeLarge,
                                    ),
                                    Text(strings.importLib),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(strings.newLib),
                  Icon(Icons.add_rounded),
                ],
              ),
            );
          }

          // All libraries.
          if (index == LibrariesProvider.instance.libraries.length) {
            return UnavailableContentWidget(
              child: _buildLibraryEntry(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => UnreleasedFeatureDialog(),
                  );
                },
                child: Text("${strings.all} (${LibrariesProvider.instance.totalBooksCount})"),
              ),
            );
          }

          final LibraryPreview library = LibrariesProvider.instance.libraries[index];
          final bool selectedLibrary = library.raw == LibraryContentProvider.instance.library;

          // Simple library.
          return _buildLibraryEntry(
            onPressed: () {
              final NavigatorState navigator = Navigator.of(context);

              // Load the selected library's content.
              LibraryContentProvider.instance.clear();
              LibraryContentProvider.instance.fetchLibraryContent(library.raw);

              navigator.pop();
            },
            highlighted: selectedLibrary,
            child: Row(
              spacing: Themes.spacingSmall,
              children: [
                if (selectedLibrary)
                  Icon(
                    Icons.double_arrow_rounded,
                    size: Themes.iconSizeSmall,
                  ),
                Expanded(
                  child: Text(
                    library.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedLibrary)
                  Transform.flip(
                    flipX: true,
                    child: Icon(
                      Icons.double_arrow_rounded,
                      size: Themes.iconSizeSmall,
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLibraryEntry({
    required Widget child,
    void Function()? onPressed,
    bool highlighted = false,
  }) {
    return Card(
      color: highlighted ? ShelflessColors.secondary : null,
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

  Widget _buildNewLibraryOption({
    required Widget child,
    void Function()? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: Themes.thumbnailSizeSmall,
        height: Themes.thumbnailSizeSmall,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
