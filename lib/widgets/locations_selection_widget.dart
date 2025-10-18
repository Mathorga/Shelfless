import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_location_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/location_label_widget.dart';
import 'package:shelfless/widgets/selection_widget/selection_controller.dart';
import 'package:shelfless/widgets/selection_widget/multiple_selection_widget.dart';

class LocationsSelectionWidget extends StatefulWidget {
  /// Already selected location ids.
  final List<int?> selectedLocationIds;

  /// Whether the widget should allow the user to add a new location if not present already.
  final bool insertNew;

  /// Called when a new set of locations is selected from the source list,
  final void Function(Set<int?> locationIds)? onLocationsSelected;

  /// Called when a location is removed from the selection list.
  final void Function(int locationId)? onLocationUnselected;

  LocationsSelectionWidget({
    super.key,
    List<int?>? inSelectedIds,
    this.insertNew = false,
    this.onLocationsSelected,
    this.onLocationUnselected,
  }) : selectedLocationIds = inSelectedIds ?? [];

  @override
  State<LocationsSelectionWidget> createState() => _LocationsSelectionWidgetState();
}

class _LocationsSelectionWidgetState extends State<LocationsSelectionWidget> {
  final SelectionController _selectionController = SelectionController(
    sourceIds: LibraryContentProvider.instance.locations.keys.toList(),
  );

  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      _selectionController.setSourceIds(LibraryContentProvider.instance.locations.keys.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultipleSelectionWidget(
      title: strings.bookInfoLocations,
      controller: _selectionController,
      inSelectedIds: widget.selectedLocationIds,
      onInsertNewRequested: widget.insertNew
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditLocationScreen(),
                ),
              );
            }
          : null,
      onItemsSelected: widget.onLocationsSelected,
      onItemUnselected: widget.onLocationUnselected,
      listItemsFilter: (int? locationId, String? filter) =>
          filter != null ? LibraryContentProvider.instance.locations[locationId].toString().toLowerCase().contains(filter) : true,
      listItemBuilder: (int? locationId) {
        final StoreLocation? location = LibraryContentProvider.instance.locations[locationId];

        if (location == null) return Placeholder();

        return LocationLabelWidget(location: location);
      },
    );
  }
}
