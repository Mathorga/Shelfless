import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  List<int?> sourceIds;

  SelectionController({
    this.sourceIds = const [],
  });

  void setIds(List<int?> ids) {
    sourceIds = ids;
    notifyListeners();
  }
}