import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:shelfish/models/publisher.dart';

class PublishersProvider with ChangeNotifier {
  final Box<Publisher> _publishers = Hive.box<Publisher>("publishers");

  /// Returns all saved books.
  List<Publisher> get publishers {
    return [..._publishers.values.toList()];
  }

  /// Saves a publisher.
  void addPublisher(Publisher publisher) {
    _publishers.add(publisher);
    notifyListeners();
  }

  /// Updates the provided publisher.
  void updatePublisher(Publisher publisher) {
    publisher.save();
    notifyListeners();
  }

  /// Deletes the provided publisher.
  void deletePublisher(Publisher publisher) {
    publisher.delete();
    notifyListeners();
  }
}