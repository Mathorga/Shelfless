import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/providers/library_filters_provider.dart';
import 'package:shelfless/screens/edit_location_screen.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/location_preview_widget.dart';

class LocationsOverviewScreen extends StatefulWidget {
  final String searchValue;

  const LocationsOverviewScreen({
    super.key,
    this.searchValue = "",
  });

  @override
  State<LocationsOverviewScreen> createState() => _LocationsOverviewScreenState();
}

class _LocationsOverviewScreenState extends State<LocationsOverviewScreen> {
  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      if (context.mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.locationsSectionTitle),
      ),
      body: SafeArea(
        child: LibraryContentProvider.instance.locations.isEmpty
            ? Center(
                child: Text(strings.noLocationsFound),
              )
            : ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(12.0),
                children: [
                  ...List.generate(
                    LibraryContentProvider.instance.locations.length,
                    (int index) {
                      // Make sure the received index is somewhat valid.
                      if (index > LibraryContentProvider.instance.locations.values.length) return const Placeholder();
        
                      // Prefetch the publisher for later use.
                      StoreLocation? location = LibraryContentProvider.instance.locations.values.toList()[index];
        
                      return LocationPreviewWidget(
                        location: location,
                        onTap: () {
                          final NavigatorState navigator = Navigator.of(context);
        
                          // Filter the current library by the selected location.
                          LibraryContentProvider.instance.applyFilters(
                            LibraryFilters(
                              inLocationsFilter: {location.id},
                            ),
                          );
        
                          navigator.pop();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: fabAccessHeight),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const EditLocationScreen(),
            ),
          );
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
