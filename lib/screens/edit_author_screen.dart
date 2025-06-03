import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditAuthorScreen extends StatefulWidget {
  static const String routeName = "/edit-author";

  final Author? author;

  const EditAuthorScreen({
    super.key,
    this.author,
  });

  @override
  State<EditAuthorScreen> createState() => _EditAuthorScreenState();
}

class _EditAuthorScreenState extends State<EditAuthorScreen> {
  late Author _author;

  // Insert flag: tells whether the widget is used for adding or editing an author.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.author == null;

    _author = widget.author != null
        ? widget.author!.copy()
        : Author(
            firstName: "",
            lastName: "",
          );
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.authorTitle}"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First name.
                EditSectionWidget(
                  children: [
                    Text(strings.authorInfoFirstName),
                    Themes.spacer,
                    TextFormField(
                      initialValue: _author.firstName,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      onChanged: (String value) => _author.firstName = value,
                    ),
                  ],
                ),
          
                // Last name.
                EditSectionWidget(
                  children: [
                    Text(strings.authorInfoLastName),
                    Themes.spacer,
                    TextFormField(
                      initialValue: _author.lastName,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onChanged: (String value) => _author.lastName = value,
                    ),
                  ],
                ),
          
                // Home Land.
                EditSectionWidget(
                  children: [
                    Text(strings.authorInfoHomeland),
                    Themes.spacer,
                    TextFormField(
                      initialValue: _author.homeLand,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                      onChanged: (String value) => _author.homeLand = value,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Actually save the author.
            _inserting ? LibraryContentProvider.instance.addAuthor(_author) : LibraryContentProvider.instance.updateAuthor(widget.author!..copyFrom(_author));
            Navigator.of(context).pop();
          },
          label: Row(
            spacing: Themes.spacingMedium,
            children: [
              Text(strings.editDone),
              const Icon(Icons.check),
            ],
          ),
        ),
      ),
    );
  }
}
