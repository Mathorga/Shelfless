import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/widgets/location_preview_widget.dart';

class LocationsOverviewScreen extends StatefulWidget {
  static const String routeName = "/locations_overview";

  const LocationsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<LocationsOverviewScreen> createState() => _LocationsOverviewScreenState();
}

class _LocationsOverviewScreenState extends State<LocationsOverviewScreen> {
  final Box<StoreLocation> _locations = Hive.box<StoreLocation>("store_locations");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Locations"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              onSelected: (String item) {},
              tooltip: "Sort by",
              itemBuilder: (BuildContext context) {
                return {
                  "Title",
                  "Author",
                  "Genre",
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(8.0),
          children: [
            ...List.generate(
              _locations.length,
              (int index) => LocationPreviewWidget(
                location: _locations.getAt(index)!,
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditGenreScreen.routeName);
          },
          child: const Icon(Icons.add_rounded),
        ));
  }
}
