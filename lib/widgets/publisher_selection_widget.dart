import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/publisher_label_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/selection_widget/single_selection_widget.dart';

class PublisherSelectionWidget extends StatefulWidget {
  /// Already selected publisher id.
  final int? inSelectedId;

  /// Whether the widget should allow the user to add a new publisher if not present already.
  final bool insertNew;

  /// Called when a publisher is selected from the source list,
  final void Function(int? publisherId)? onPublisherSelected;

  /// Called when the publisher selection is cleared.
  final void Function(int publisherId)? onPublisherUnselected;

  const PublisherSelectionWidget({
    super.key,
    this.inSelectedId,
    this.insertNew = false,
    this.onPublisherSelected,
    this.onPublisherUnselected,
  });

  @override
  State<PublisherSelectionWidget> createState() => _PublisherSelectionWidgetState();
}

class _PublisherSelectionWidgetState extends State<PublisherSelectionWidget> {
  late final SelectionController<int?> _selectionController = SelectionController(
    domain: LibraryContentProvider.instance.publishers.keys.toList(),
    selection: {if (widget.inSelectedId != null) widget.inSelectedId}
  );
  final ScrollController _searchScrollController = ScrollController();

  @override
  void didUpdateWidget(covariant PublisherSelectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _selectionController.setSelection({if (widget.inSelectedId != null) widget.inSelectedId});
  }

  @override
  void dispose() {
    // Get rid of controllers.
    _selectionController.dispose();
    _searchScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleSelectionWidget(
      title: strings.bookInfoPublisher,
      selectionController: _selectionController,
      searchScrollController: _searchScrollController,
      onInsertNewRequested: widget.insertNew
          ? () async {
              final Publisher? newPublisher = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => const EditPublisherScreen(),
                ),
              );

              if (newPublisher == null) return;

              _selectionController.addToDomain(newPublisher.id, select: false);
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
