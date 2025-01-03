import 'package:flutter/material.dart';

import 'package:shelfless/models/library.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/database_helper.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditLibraryScreen extends StatefulWidget {
  static const String routeName = "/edit-library";

  final int? libraryId;

  const EditLibraryScreen({
    Key? key,
    this.libraryId,
  }) : super(key: key);

  @override
  State<EditLibraryScreen> createState() => _EditLibraryScreenState();
}

class _EditLibraryScreenState extends State<EditLibraryScreen> {
  Library? _library;

  bool _loadingLibrary = true;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.libraryId == null;

    if (widget.libraryId == null) {
      WidgetsBinding.instance.addPostFrameCallback((Duration duration) => Navigator.of(context).pop());
      return;
    }

    _fetchLibrary();
  }

  /// Asks the DB for the library with the provided id.
  Future<void> _fetchLibrary() async {
    _library = await DatabaseHelper.instance.getLibrary(widget.libraryId!);

    setState(() {
      _loadingLibrary = false;
    });
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
                    initialValue: _library?.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (String value) => _library?.name = value,
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
                _inserting ? DatabaseHelper.instance.insertLibrary(_library!) : DatabaseHelper.instance.updateLibrary(_library!);
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
          if (_loadingLibrary)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
