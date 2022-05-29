import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/providers/store_locations_provider.dart';

class EditLocationScreen extends StatefulWidget {
  static const String routeName = "/edit-location";

  const EditLocationScreen({Key? key}) : super(key: key);

  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {

  String name = "";
  int color = Colors.white.value;

  @override
  Widget build(BuildContext context) {
    // Fetch provider to save changes.
    final StoreLocationsProvider locationsProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Location"),
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
          final StoreLocation location = StoreLocation(
            name: name.trim(),
          );
          locationsProvider.addLocation(location);
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
    );
  }
}
