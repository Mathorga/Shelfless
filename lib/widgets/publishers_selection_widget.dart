import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/publisher_label_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/selection_widget/multiple_selection_widget.dart';

class PublishersSelectionWidget extends StatefulWidget {
  /// Already selected publisher ids.
  final List<int?> selectedPublisherIds;

  /// Whether the widget should allow the user to add a new publisher if not present already.
  final bool insertNew;

  /// Called when a new set of publishers is selected from the source list,
  final void Function(Set<int?> publisherIds)? onPublishersSelected;

  /// Called when a publisher is removed from the selection list.
  final void Function(int publisherId)? onPublisherUnselected;

  PublishersSelectionWidget({
    super.key,
    List<int?>? inSelectedIds,
    this.insertNew = false,
    this.onPublishersSelected,
    this.onPublisherUnselected,
  }) : selectedPublisherIds = inSelectedIds ?? [];

  @override
  State<PublishersSelectionWidget> createState() => _PublishersSelectionWidgetState();
}

class _PublishersSelectionWidgetState extends State<PublishersSelectionWidget> {
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
    return MultipleSelectionWidget(
      title: strings.bookInfoPublishers,
      selectionController: _selectionController,
      // inSelectedIds: widget.selectedPublisherIds,
      onInsertNewRequested: widget.insertNew
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditPublisherScreen(),
                ),
              );
            }
          : null,
      onItemsSelected: widget.onPublishersSelected,
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
