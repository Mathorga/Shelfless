import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shelfish/models/publisher.dart';

import 'package:shelfish/providers/publishers_provider.dart';
import 'package:shelfish/utils/strings.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class EditPublisherScreen extends StatefulWidget {
  static const String routeName = "/edit-publisher";

  const EditPublisherScreen({Key? key}) : super(key: key);

  @override
  _EditPublisherScreenState createState() => _EditPublisherScreenState();
}

class _EditPublisherScreenState extends State<EditPublisherScreen> {
  Publisher _publisher = Publisher(
    name: "",
  );

  // Insert flag: tells whether the widget is used for adding or editing a publisher.
  bool _inserting = true;

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
              Text(strings.publisherInfoName),
              TextFormField(
                initialValue: _publisher.name,
                textCapitalization: TextCapitalization.words,
                onChanged: (String value) => _publisher.name = value,
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
            _inserting ? publishersProvider.addPublisher(_publisher) : publishersProvider.updatePublisher(_publisher);
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
