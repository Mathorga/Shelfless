import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_location_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/location_label_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/selection_widget/ids_selection_controller.dart';
import 'package:shelfless/widgets/selection_widget/single_selection_widget.dart';

class LocationSelectionWidget extends StatefulWidget {
  /// Already selected location id.
  final int? selectedLocationId;

  /// Whether the widget should allow the user to add a new location if not present already.
  final bool insertNew;

  /// Called when a location is selected from the source list,
  final void Function(int? locationId)? onLocationSelected;

  /// Called when the location selection is cleared.
  final void Function(int locationId)? onLocationUnselected;

  const LocationSelectionWidget({
    super.key,
    this.selectedLocationId,
    this.insertNew = false,
    this.onLocationSelected,
    this.onLocationUnselected,
  });

  @override
  State<LocationSelectionWidget> createState() => _LocationSelectionWidgetState();
}

class _LocationSelectionWidgetState extends State<LocationSelectionWidget> {
  final SelectionController<int?> _selectionController = SelectionController(
    domain: LibraryContentProvider.instance.locations.keys.toList(),
  );

  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      _selectionController.setDomain(LibraryContentProvider.instance.locations.keys.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleSelectionWidget(
      title: strings.bookInfoLocation,
      selectionController: _selectionController,
      inSelectedIds: [widget.selectedLocationId].nonNulls.toSet(),
      onInsertNewRequested: widget.insertNew
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditLocationScreen(),
                ),
              );
            }
          : null,
      onItemSelected: widget.onLocationSelected,
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
