import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/libraries_provider.dart';
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
              child: Text("No libraries yet"),
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
                    onTap: () => Navigator.of(context).pushNamed(LibraryScreen.routeName, arguments: _libraries[index]),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
