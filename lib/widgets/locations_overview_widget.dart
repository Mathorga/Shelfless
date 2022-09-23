import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/providers/store_locations_provider.dart';
import 'package:shelfish/screens/books_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/publisher_info_screen.dart';
import 'package:shelfish/widgets/location_preview_widget.dart';

class LocationsOverviewWidget extends StatelessWidget {
  final String searchValue;

  const LocationsOverviewWidget({
    Key? key,
    this.searchValue = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StoreLocationsProvider locationsProvider = Provider.of(context, listen: true);
    final LibrariesProvider librariesProvider = Provider.of(context, listen: true);

    // Fetch all relevant authors based on the currently viewed library. All if no specific library is selected.
    final List<StoreLocation> unfilteredLocations = librariesProvider.currentLibrary != null
        ? librariesProvider.currentLibrary!.books
            .where((Book book) => book.publisher != null)
            .map<StoreLocation>((Book book) => book.location!)
            .fold(<StoreLocation>[], (List<StoreLocation> result, StoreLocation element) => result..add(element))
            .toSet()
            .toList()
        : locationsProvider.locations;

    final List<StoreLocation> locations = unfilteredLocations.where((StoreLocation publisher) => publisher.toString().toLowerCase().contains(searchValue.toLowerCase())).toList();

    return Scaffold(
        body: locations.isEmpty
            ? const Center(
                child: Text("No locations found"),
              )
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 16 / 9,
                padding: const EdgeInsets.all(12.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  ...List.generate(
                    locations.length,
                    (index) => GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => BooksScreen(location: locations[index]),
                        ),
                      ),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: double.infinity,
                            child: LocationPreviewWidget(
                              location: locations[index],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Edit the selected author.
                                Navigator.of(context).pushNamed(PublisherInfoScreen.routeName, arguments: locations[index]);
                              },
                              icon: const Icon(Icons.settings_rounded),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditAuthorScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
