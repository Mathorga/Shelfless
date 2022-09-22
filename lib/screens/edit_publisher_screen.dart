import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shelfish/models/publisher.dart';

import 'package:shelfish/providers/publishers_provider.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class EditPublisherScreen extends StatefulWidget {
  static const String routeName = "/edit-publisher";

  const EditPublisherScreen({Key? key}) : super(key: key);

  @override
  _EditPublisherScreenState createState() => _EditPublisherScreenState();
}

class _EditPublisherScreenState extends State<EditPublisherScreen> {

  String name = "";
  int color = Colors.white.value;

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final PublishersProvider publishersProvider = Provider.of(context, listen: false);

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Insert Publisher"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Name"),
              TextField(
                onChanged: (String value) => name = value,
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
            // Actually save a new genre.
            final Publisher publisher = Publisher(
              name: name.trim(),
            );
            publishersProvider.addPublisher(publisher);
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
