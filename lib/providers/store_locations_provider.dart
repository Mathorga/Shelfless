import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/store_location.dart';

class StoreLocationsProvider with ChangeNotifier {
  final Box<StoreLocation> _locations = Hive.box<StoreLocation>("store_locations");

  /// Returns all saved books.
  List<StoreLocation> get locations {
    return [..._locations.values.toList()];
  }

  /// Saves a location.
  void addLocation(StoreLocation storeLocation) {
    _locations.add(storeLocation);
    notifyListeners();
  }

  /// Updates the provided location.
  void updateLocation(StoreLocation storeLocation) {
    storeLocation.save();
    notifyListeners();
  }

  /// Deletes the provided location.
  void deleteLocation(StoreLocation location) {
    location.delete();
    notifyListeners();
  }
}