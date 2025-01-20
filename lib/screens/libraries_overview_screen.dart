import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

import 'package:shelfless/models/library.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_library_screen.dart';
import 'package:shelfless/screens/library_content_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/library_preview_widget.dart';

class LibrariesOverviewScreen extends StatefulWidget {
  static const String routeName = "/libraries_overview";

  const LibrariesOverviewScreen({Key? key}) : super(key: key);

  @override
  State<LibrariesOverviewScreen> createState() => _LibrariesOverviewScreenState();
}

class _LibrariesOverviewScreenState extends State<LibrariesOverviewScreen> {
  final GlobalKey _fabKey = GlobalKey<ExpandableFabState>();

  @override
  void initState() {
    super.initState();

    LibrariesProvider.instance.fetchLibraries();
    LibrariesProvider.instance.addListener(() => setState(() {}));
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(strings.librariesTitle),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // backgroundColor: ShelfishColors.librariesBackground,
      body: LibrariesProvider.instance.libraries.isNotEmpty
          ? ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  LibrariesProvider.instance.libraries.length + 1,
                  (int index) => GestureDetector(
                    // Navigate to library screen.
                    onTap: () async {
                      // Prefetch handlers before async gaps.
                      final NavigatorState navigator = Navigator.of(context);

                      final int? libraryId = LibrariesProvider.instance.libraries[index].raw.id;

                      // Head out if, for any reason, the selected library has no id.
                      if (libraryId == null) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: Text(strings.warning),
                            content: Text(strings.genericError),
                          ),
                        );

                        return;
                      }

                      LibraryPreview library = LibrariesProvider.instance.libraries[index];
                      LibraryContentProvider.instance.fetchLibraryContent(library.raw);

                      navigator.push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => LibraryContentScreen(
                            library: library,
                          ),
                        ),
                      );
                    },
                    child: index < LibrariesProvider.instance.libraries.length
                        // Library preview.
                        ? Stack(
                            children: [
                              LibraryPreviewWidget(
                                library: LibrariesProvider.instance.libraries[index],
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  onPressed: () {
                                    // Go to library info.
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) => EditLibraryScreen(
                                          library: LibrariesProvider.instance.libraries[index],
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit_rounded,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: IconButton(
                                  onPressed: () {
                                    _showDeleteDialog(LibrariesProvider.instance.libraries[index]);
                                  },
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 2.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )

                        // All libraries.
                        : Card(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  "${strings.all} (${LibrariesProvider.instance.totalBooksCount} ${LibrariesProvider.instance.totalBooksCount == 1 ? strings.book : strings.books})",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                  ),
                )
              ],
            )
          : Center(
              child: Text(strings.noLibrariesFound),
            ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: _fabKey,
        type: ExpandableFabType.up,
        overlayStyle: ExpandableFabOverlayStyle(blur: 5.0, color: ShelflessColors.mainBackground.withAlpha(0x7F)),
        openButtonBuilder: RotateFloatingActionButtonBuilder(
          child: Icon(Icons.add_rounded),
        ),
        closeButtonBuilder: DefaultFloatingActionButtonBuilder(child: Icon(Icons.close_rounded)),
        children: [
          // Import an existing library from file.
          Row(
            spacing: Themes.spacingMedium,
            children: [
              Text(strings.importLib),
              FloatingActionButton(
                heroTag: "import_library",
                child: const Icon(Icons.upload_rounded),
                onPressed: () async {
                  // Pick a library file.
                  FilePickerResult? result = await FilePicker.platform.pickFiles();

                  if (result != null) {
                    // TODO
                    // // Retrieve the file name.
                    // String fileName = result.files.single.name.split(".").first;

                    // // Read the file.
                    // File file = File(result.files.single.path!);
                    // String fileContent = await file.readAsString();

                    // // Create and add the library to DB.
                    // librariesProvider.addLibrary(Library.fromSerializableString(name: fileName, csvString: fileContent));
                  } else {
                    // User canceled the picker
                  }
                },
              ),
            ],
          ),

          // Create a library anew.
          Row(
            spacing: Themes.spacingMedium,
            children: [
              Text(strings.newLib),
              FloatingActionButton(
                heroTag: "create_library",
                child: const Icon(Icons.create_new_folder_rounded),
                onPressed: () async {
                  // Prefetch handlers before async gaps.
                  final NavigatorState navigator = Navigator.of(context);

                  final ExpandableFabState state = _fabKey.currentState as ExpandableFabState;

                  // Navigate to library creation screen.
                  await navigator.push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => const EditLibraryScreen(),
                    ),
                  );

                  state.toggle();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(LibraryPreview library) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(strings.deleteLibraryTitle),
          content: Text(strings.deleteLibraryContent),
          actions: [
            TextButton(
              onPressed: () {
                // Prefetch handlers before async gaps.
                final NavigatorState navigator = Navigator.of(context);

                navigator.pop();
              },
              child: Text("cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                // Prefetch handlers before async gaps.
                final NavigatorState navigator = Navigator.of(context);

                await LibrariesProvider.instance.deleteLibrary(library);

                navigator.pop();
              },
              child: Text(strings.ok),
            ),
          ],
        );
      },
    );
  }
}
