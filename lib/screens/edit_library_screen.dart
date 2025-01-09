import 'package:flutter/material.dart';

import 'package:shelfless/models/raw_library.dart';
import 'package:shelfless/models/library_preview.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditLibraryScreen extends StatefulWidget {
  static const String routeName = "/edit-library";

  final LibraryPreview? library;

  const EditLibraryScreen({
    Key? key,
    this.library,
  }) : super(key: key);

  @override
  State<EditLibraryScreen> createState() => _EditLibraryScreenState();
}

class _EditLibraryScreenState extends State<EditLibraryScreen> {
  LibraryPreview? _library;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.library == null;

    _library = widget.library ?? LibraryPreview(raw: RawLibrary());
  }

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    return UnfocusWidget(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.libraryTitle}"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(strings.libraryInfoName),
                  Themes.spacer,
                  TextFormField(
                    initialValue: _library?.raw.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (String value) => _library?.raw.name = value,
                  ),
                  const SizedBox(
                    height: 24.0,
                    child: Divider(height: 2.0),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                // Actually save the library.
                _inserting ? LibrariesProvider.instance.addLibrary(_library!) : LibrariesProvider.instance.updateLibrary(_library!);
                Navigator.of(context).pop();
              },
              label: Row(
                children: [
                  Text(strings.editDone),
                  const SizedBox(width: 12.0),
                  const Icon(Icons.check),
                ],
              ),
            ),
          ),
          if (_library == null)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
