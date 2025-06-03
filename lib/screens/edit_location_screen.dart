import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditLocationScreen extends StatefulWidget {
  final StoreLocation? location;

  const EditLocationScreen({
    super.key,
    this.location,
  });

  @override
  State<EditLocationScreen> createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  late StoreLocation _location;

  // Insert flag: tells whether the widget is used for adding or editing a location.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.location == null;

    _location = widget.location != null
        ? widget.location!.copy()
        : StoreLocation(
            name: "",
          );
  }

  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.locationTitle}"),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EditSectionWidget(
                  children: [
                    Text(strings.locationInfoName),
                    Themes.spacer,
                    TextFormField(
                      initialValue: _location.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (String value) => _location.name = value,
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
            _inserting ? LibraryContentProvider.instance.addLocation(_location) : LibraryContentProvider.instance.updateLocation(widget.location!..copyFrom(_location));
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
