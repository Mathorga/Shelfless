import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/publisher.dart';
import 'package:shelfish/providers/publishers_provider.dart';
import 'package:shelfish/screens/edit_publisher_screen.dart';
import 'package:shelfish/utils/strings.dart';
import 'package:shelfish/widgets/delete_dialog.dart';

class PublisherInfoScreen extends StatefulWidget {
  static const String routeName = "/publisher-info";

  const PublisherInfoScreen({Key? key}) : super(key: key);

  @override
  State<PublisherInfoScreen> createState() => _PublisherInfoScreenState();
}

class _PublisherInfoScreenState extends State<PublisherInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch provider.
    final PublishersProvider publishersProvider = Provider.of(context, listen: true);

    // Fetch publisher.
    Publisher publisher = ModalRoute.of(context)!.settings.arguments as Publisher;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.publisherInfo,
          style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to edit_book_screen.
              Navigator.of(context).pushNamed(EditPublisherScreen.routeName, arguments: publisher);
            },
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {
              // Show dialog asking the user to confirm their choice.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteDialog(title: publisher.toString(), onYes: () => publishersProvider.deletePublisher(publisher), onNo: null);
                },
              );
            },
            icon: const Icon(Icons.delete_rounded),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First name.
              Text(strings.publisherInfoName),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(publisher.name, style: Theme.of(context).textTheme.headline6),
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
