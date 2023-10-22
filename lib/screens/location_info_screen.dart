import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/dialogs/delete_dialog.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/store_locations_provider.dart';
import 'package:shelfless/screens/edit_location_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';

class LocationInfoScreen extends StatefulWidget {
  static const String routeName = "/location-info";

  const LocationInfoScreen({Key? key}) : super(key: key);

  @override
  State<LocationInfoScreen> createState() => _LocationInfoScreenState();
}

class _LocationInfoScreenState extends State<LocationInfoScreen> {
  @override
  Widget build(BuildContext context) {
    // Fetch provider.
    final StoreLocationsProvider locationsProvider = Provider.of(context, listen: true);

    // Fetch location.
    StoreLocation location = ModalRoute.of(context)!.settings.arguments as StoreLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.locationInfo,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to edit screen.
              Navigator.of(context).pushNamed(EditLocationScreen.routeName, arguments: location);
            },
            icon: const Icon(Icons.edit_rounded),
          ),
          IconButton(
            onPressed: () {
              // Show dialog asking the user to confirm their choice.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return DeleteDialog(
                    title: Text("$location"),
                    onConfirm: () => locationsProvider.deleteLocation(location),
                  );
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
              // Name.
              Text(strings.locationInfoName),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  location.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
