import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/publisher_label_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/selection_widget/ids_selection_controller.dart';
import 'package:shelfless/widgets/selection_widget/single_selection_widget.dart';

class PublisherSelectionWidget extends StatefulWidget {
  /// Already selected publisher id.
  final int? selectedPublisherId;

  /// Whether the widget should allow the user to add a new publisher if not present already.
  final bool insertNew;

  /// Called when a publisher is selected from the source list,
  final void Function(int? publisherId)? onPublisherSelected;

  /// Called when the publisher selection is cleared.
  final void Function(int publisherId)? onPublisherUnselected;

  const PublisherSelectionWidget({
    super.key,
    this.selectedPublisherId,
    this.insertNew = false,
    this.onPublisherSelected,
    this.onPublisherUnselected,
  });

  @override
  State<PublisherSelectionWidget> createState() => _PublisherSelectionWidgetState();
}

class _PublisherSelectionWidgetState extends State<PublisherSelectionWidget> {
  final SelectionController<int?> _selectionController = SelectionController(
    domain: LibraryContentProvider.instance.publishers.keys.toList(),
  );

  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      _selectionController.setDomain(LibraryContentProvider.instance.publishers.keys.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleSelectionWidget(
      title: strings.bookInfoPublisher,
      controller: _selectionController,
      inSelectedIds: [widget.selectedPublisherId].nonNulls.toSet(),
      onInsertNewRequested: widget.insertNew
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditPublisherScreen(),
                ),
              );
            }
          : null,
      onItemSelected: widget.onPublisherSelected,
      onItemUnselected: widget.onPublisherUnselected,
      listItemsFilter: (int? publisherId, String? filter) =>
          filter != null ? LibraryContentProvider.instance.publishers[publisherId].toString().toLowerCase().contains(filter) : true,
      listItemBuilder: (int? publisherId) {
        final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

        if (publisher == null) return Placeholder();

        return PublisherLabelWidget(publisher: publisher);
      },
    );
  }
}
