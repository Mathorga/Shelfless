import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/slippery_text_form_field_widget.dart';

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
    return Scaffold(
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
                spacing: Themes.spacingMedium,
                children: [
                  Text(strings.authorInfoFirstName),
                  SlipperyTextFormFieldWidget(
                    initialValue: widget.author?.firstName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => _author.firstName = value,
                  ),
                ],
              ),

              // Last name.
              EditSectionWidget(
                spacing: Themes.spacingMedium,
                children: [
                  Text(strings.authorInfoLastName),
                  SlipperyTextFormFieldWidget(
                    initialValue: widget.author?.lastName,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    onChanged: (String value) => _author.lastName = value,
                  ),
                ],
              ),

              // Home Land.
              EditSectionWidget(
                spacing: Themes.spacingMedium,
                children: [
                  Text(strings.authorInfoHomeland),
                  SlipperyTextFormFieldWidget(
                    initialValue: widget.author?.homeLand,
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
        onPressed: () async {
          final NavigatorState navigator = Navigator.of(context);

          // Actually save the author and pop it back.
          _inserting ? await LibraryContentProvider.instance.addAuthor(_author) : await LibraryContentProvider.instance.updateAuthor(widget.author!..copyFrom(_author));
          navigator.pop(_author);
        },
        label: Row(
          spacing: Themes.spacingMedium,
          children: [
            Text(strings.editDone),
            const Icon(Icons.check),
          ],
        ),
      ),
    );
  }
}
