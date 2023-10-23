import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/store_locations_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditLocationScreen extends StatefulWidget {
  static const String routeName = "/edit-location";

  final StoreLocation? location;

  const EditLocationScreen({
    Key? key,
    this.location,
  }) : super(key: key);

  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  late StoreLocation _location;

  // Insert flag: tells whether the widget is used for adding or editing.
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
    // Fetch provider to save changes.
    final StoreLocationsProvider locationsProvider = Provider.of(context, listen: false);

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${strings.insertTitle} ${strings.locationTitle}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
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
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Actually save the location.
            _inserting ? locationsProvider.addLocation(_location) : locationsProvider.updateLocation(widget.location!..copyFrom(_location));
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
