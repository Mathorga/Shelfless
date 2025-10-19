import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

class SingleSelectionWidget extends StatelessWidget {
  final String? title;
  final SelectionController<int?> controller;
  final void Function()? onInsertNewRequested;
  final bool Function(int? id, String? filter) listItemsFilter;
  final Widget Function(int? id) listItemBuilder;
  final Set<int?> selecteIds;
  final void Function(int? id)? onItemSelected;
  final void Function(int id)? onItemUnselected;

  SingleSelectionWidget({
    super.key,
    this.title,
    required this.controller,
    this.onInsertNewRequested,
    required this.listItemsFilter,
    required this.listItemBuilder,
    Set<int?>? inSelectedIds,
    this.onItemSelected,
    this.onItemUnselected,
  }) : selecteIds = inSelectedIds ?? {};

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
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  // Make sure updates are reacted to.
                  controller.addListener(() {
                    if (context.mounted) setState(() {});
                  });

                  return SearchListWidget<int?>(
                    selectionController: controller,
                    multiple: false,
                    filter: listItemsFilter,
                    builder: listItemBuilder,
                    onElementsSelected: (Set<int?> selectedIds) {
                      // Prefetch handlers.
                      final NavigatorState navigator = Navigator.of(context);

                      onItemSelected?.call(selectedIds.first);

                      navigator.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (selecteIds.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: selecteIds.map((int? id) => _buildPreview(id)).toList(),
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
