import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

// TODO Merge with MultipleSelectionWidget.
class SingleSelectionWidget extends StatelessWidget {
  final String? title;
  final SelectionController<int?> selectionController;
  final ScrollController? searchScrollController;
  final void Function()? onInsertNewRequested;
  final bool Function(int? id, String? filter) listItemsFilter;
  final Widget Function(int? id) listItemBuilder;
  final void Function(int? id)? onItemSelected;
  final void Function(int id)? onItemUnselected;

  const SingleSelectionWidget({
    super.key,
    this.title,
    required this.selectionController,
    this.searchScrollController,
    this.onInsertNewRequested,
    required this.listItemsFilter,
    required this.listItemBuilder,
    Set<int?>? inSelectedIds,
    this.onItemSelected,
    this.onItemUnselected,
  });

  @override
  Widget build(BuildContext context) {
    return EditSectionWidget(
      spacing: Themes.spacingMedium,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null) Text(title!),
            DialogButtonWidget(
              label: Text(strings.select),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null) Text(title!),
                  if (onInsertNewRequested != null)
                    TextButton(
                      onPressed: onInsertNewRequested,
                      child: Text(strings.add),
                    ),
                ],
              ),
              content: SearchListWidget<int?>(
                selectionController: selectionController,
                scrollController: searchScrollController,
                multiple: false,
                filter: listItemsFilter,
                builder: listItemBuilder,
                onElementsSelected: (Set<int?> selectedIds) {
                  onItemSelected?.call(selectedIds.first);

                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
        if (selectionController.selection.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: selectionController.selection.map((int? id) => _buildPreview(id)).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildPreview(int? id) {
    if (id == null) return Placeholder();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: listItemBuilder(id),
        ),
        TextButton(
          onPressed: () {
            selectionController.removeFromSelection({id});
            onItemUnselected?.call(id);
          },
          child: Icon(
            Icons.close_rounded,
            color: ShelflessColors.errorLight,
          ),
        ),
      ],
    );
  }
}
