import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/utils/strings/strings.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class EditAuthorScreen extends StatefulWidget {
  static const String routeName = "/edit-author";

  const EditAuthorScreen({Key? key}) : super(key: key);

  @override
  _EditAuthorScreenState createState() => _EditAuthorScreenState();
}

class _EditAuthorScreenState extends State<EditAuthorScreen> {
  Author _author = Author(
    firstName: "",
    lastName: "",
  );

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final AuthorsProvider authorsProvider = Provider.of(context, listen: false);

    // Fetch passed arguments.
    Author? receivedAuthor = ModalRoute.of(context)!.settings.arguments as Author?;
    _inserting = receivedAuthor == null;

    if (!_inserting) {
      _author = receivedAuthor!;
    }

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.authorTitle}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(strings.authorInfoFirstName),
              TextFormField(
                initialValue: _author.firstName,
                textCapitalization: TextCapitalization.words,
                onChanged: (String value) => _author.firstName = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              Text(strings.authorInfoLastName),
              TextFormField(
                initialValue: _author.lastName,
                textCapitalization: TextCapitalization.words,
                onChanged: (String value) => _author.lastName = value,
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
            _inserting ? authorsProvider.addAuthor(_author) : authorsProvider.updateAuthor(_author);
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
