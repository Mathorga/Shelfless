import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/utils/strings.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class ImportLibraryScreen extends StatefulWidget {
  static const String routeName = "/import-library";

  const ImportLibraryScreen({Key? key}) : super(key: key);

  @override
  _ImportLibraryScreenState createState() => _ImportLibraryScreenState();
}

class _ImportLibraryScreenState extends State<ImportLibraryScreen> {
  final Box<Book> _books = Hive.box<Book>("books");

  late Library _library;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _library = Library(
      name: "",
      books: HiveList(_books),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final LibrariesProvider _librariesProvider = Provider.of(context, listen: false);

    // Fetch passed arguments.
    // Error if no argument is passed.
    String _libraryString = ModalRoute.of(context)!.settings.arguments as String;
    print(_libraryString);

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Import Library"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Name"),
              TextFormField(
                initialValue: _library.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (String value) => _library.name = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // How many header lines does the file have?
              const Text("Header Lines"),

              // What is the field separator character?
              const Text("Fields Separator"),

              // What is the element separator character in list fields?
              const Text("List Separator"),

              // Which column holds the book title?
              const Text("Title Column"),

              // Which column holds the book genres?
              const Text("Genres Column"),

              // Which column holds the book authors?
              const Text("Authors Column"),

              // Which column holds the book publisher?
              const Text("Publisher Column"),

              // Which column holds the book publish date?
              const Text("Publish Date Column"),

              // Which column holds the book location?
              const Text("Location Column"),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Actually save the author.
            _inserting ? _librariesProvider.addLibrary(_library) : _librariesProvider.updateLibrary(_library);
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
