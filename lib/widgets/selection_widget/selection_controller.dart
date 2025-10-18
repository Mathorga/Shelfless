import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  List<int?> sourceIds;
  List<int?> selectedIds;

  SelectionController({
    this.sourceIds = const [],
    this.selectedIds = const [],
  });

  void setSourceIds(List<int?> ids) {
    sourceIds = ids;
    notifyListeners();
  }

  void addSelection(int? id) {
    selectedIds.add(id);
    notifyListeners();
  }
}