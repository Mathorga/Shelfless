import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/library.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditLibraryScreen extends StatefulWidget {
  static const String routeName = "/edit-library";

  final Library? library;

  const EditLibraryScreen({
    Key? key,
    this.library,
  }) : super(key: key);

  @override
  _EditLibraryScreenState createState() => _EditLibraryScreenState();
}

class _EditLibraryScreenState extends State<EditLibraryScreen> {
  final Box<Book> _books = Hive.box<Book>("books");

  late Library _library;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.library == null;

    _library = widget.library != null
        ? widget.library!.copy()
        : Library(
      name: "",
      books: HiveList(_books),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final LibrariesProvider _librariesProvider = Provider.of(context, listen: false);

    return UnfocusWidget(
      child: Scaffold(
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
                initialValue: _library.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (String value) => _library.name = value,
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
            // Actually save the author.
            _inserting ? _librariesProvider.addLibrary(_library) : _librariesProvider.updateLibrary(widget.library!..copyFrom(_library));
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
    );
  }
}
