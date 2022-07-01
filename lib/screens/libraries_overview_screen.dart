import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/screens/edit_library_screen.dart';
import 'package:shelfish/screens/library_screen.dart';
import 'package:shelfish/widgets/library_preview_widget.dart';

class LibrariesOverviewScreen extends StatelessWidget {
  static const String routeName = "/libraries_overview";

  const LibrariesOverviewScreen({Key? key}) : super(key: key);

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("Libraries"),
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    LibrariesProvider _librariesProvider = Provider.of(context, listen: true);
    final _libraries = _librariesProvider.libraries;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _libraries.isEmpty
          ? const Center(
              child: Text("No libraries found"),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              // crossAxisCount: 2,
              children: [
                ...List.generate(
                  _libraries.length,
                  (int index) => GestureDetector(
                    // Navigate to library screen.
                    onTap: () => Navigator.of(context).pushNamed(LibraryScreen.routeName, arguments: index),
                    child: SizedBox(
                      height: 120.0,
                      child: LibraryPreviewWidget(
                        library: _libraries[index],
                      ),
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 24.0,
        spaceBetweenChildren: 16.0,
        childrenButtonSize: const Size(64.0, 64.0),
        children: [
          SpeedDialChild(
            label: "Import",
            child: const Icon(Icons.input_rounded),
            onTap: () {
              // TODO.
            },
          ),
          SpeedDialChild(
            label: "New",
            child: const Icon(Icons.note_add_rounded),
            onTap: () {
              // Navigate to library creation screen.
              Navigator.of(context).pushNamed(EditLibraryScreen.routeName);
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add_rounded),
      // ),
    );
  }
}
