import 'package:flutter/material.dart';

class SelectionController extends ChangeNotifier {
  List<int?> sourceIds;
  Set<int?> selectedIds;

  SelectionController({
    this.sourceIds = const [],
    this.selectedIds = const {},
  });

  void setSourceIds(List<int?> ids) {
    sourceIds = [...ids];
    notifyListeners();
  }

  void setSelectedIds(Set<int?> ids) {
    selectedIds = {...ids};
    notifyListeners();
  }

  void clearSelectedIds() {
    selectedIds.clear();
    notifyListeners();
  }

  /// Adds [id] to the list of all possible source ids.
  /// If [select] is true, then [id] is also selected.
  void addSourceId(int? id, {bool select = false}) {
    sourceIds.add(id);

    if (select) selectedIds.add(id);

    notifyListeners();
  }

  void addSelection(Set<int?> ids) {
    selectedIds.addAll(ids);
    notifyListeners();
  }

  void removeSelection(Set<int?> ids) {
    selectedIds.removeAll(ids);
    notifyListeners();
  }
}