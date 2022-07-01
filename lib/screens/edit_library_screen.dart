import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/library.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class EditLibraryScreen extends StatefulWidget {
  static const String routeName = "/edit-library";

  const EditLibraryScreen({Key? key}) : super(key: key);

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
    Library? _receivedAuthor = ModalRoute.of(context)!.settings.arguments as Library?;
    _inserting = _receivedAuthor == null;

    if (!_inserting) {
      _library = _receivedAuthor!;
    }

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? "Insert" : "Edit"} Library"),
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
            children: const [
              Text("Done"),
              SizedBox(width: 12.0),
              Icon(Icons.check),
            ],
          ),
        ),
      ),
    );
  }
}
