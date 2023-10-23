import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/providers/publishers_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditPublisherScreen extends StatefulWidget {
  static const String routeName = "/edit-publisher";

  final Publisher? publisher;

  const EditPublisherScreen({
    Key? key,
    required this.publisher,
  }) : super(key: key);

  @override
  _EditPublisherScreenState createState() => _EditPublisherScreenState();
}

class _EditPublisherScreenState extends State<EditPublisherScreen> {
  late Publisher _publisher;

  // Insert flag: tells whether the widget is used for adding or editing a publisher.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _inserting = widget.publisher == null;

    _publisher = widget.publisher != null
        ? widget.publisher!.copy()
        : Publisher(
            name: "",
          );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final PublishersProvider publishersProvider = Provider.of(context, listen: false);

    // Fetch passed arguments.
    Publisher? receivedPublisher = ModalRoute.of(context)!.settings.arguments as Publisher?;
    _inserting = receivedPublisher == null;

    if (!_inserting) {
      _publisher = receivedPublisher!;
    }

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.publisherTitle}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditSectionWidget(
                children: [
                  Text(strings.publisherInfoName),
                  Themes.spacer,
                  TextFormField(
                    initialValue: _publisher.name,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (String value) => _publisher.name = value,
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Actually save the author.
            _inserting ? publishersProvider.addPublisher(_publisher) : publishersProvider.updatePublisher(widget.publisher!..copyFrom(_publisher));
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
