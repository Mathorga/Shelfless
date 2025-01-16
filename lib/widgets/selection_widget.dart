import 'package:flutter/material.dart';

import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

class SelectionWidget extends StatelessWidget {
  final Widget? previewTitle;
  final Widget? dialogTitle;
  final void Function()? onInsertNewRequested;
  final bool Function(int? id, String? filter) listItemsFilter;
  final Widget Function(int? id) listItemBuilder;
  final List<int?> selecteIds;
  final void Function(Set<int?> ids)? onItemsAdded;
  final void Function(int id)? onItemRemoved;
  final bool insertNew;

  SelectionWidget({
    super.key,
    this.previewTitle,
    this.dialogTitle,
    this.onInsertNewRequested,
    required this.listItemsFilter,
    required this.listItemBuilder,
    List<int?>? inAuthorIds,
    this.onItemsAdded,
    this.onItemRemoved,
    this.insertNew = false,
  }) : selecteIds = inAuthorIds ?? [];

  @override
  Widget build(BuildContext context) {
    return EditSectionWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (previewTitle != null) previewTitle!,
            DialogButtonWidget(
              label: const Icon(Icons.add_rounded),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (dialogTitle != null) dialogTitle!,
                  if (onInsertNewRequested != null)
                    TextButton(
                      onPressed: onInsertNewRequested,
                      child: Text(strings.add),
                    ),
                ],
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  // Make sure updates are reacted to.
                  LibraryContentProvider.instance.addListener(() {
                    if (context.mounted) setState(() {});
                  });

                  return SearchListWidget<int?>(
                    children: LibraryContentProvider.instance.authors.keys.toList(),
                    multiple: true,
                    filter: listItemsFilter,
                    builder: listItemBuilder,
                    onElementsSelected: (Set<int?> selectedAuthorIds) {
                      // Prefetch handlers.
                      final NavigatorState navigator = Navigator.of(context);

                      onItemsAdded?.call(selectedAuthorIds);

                      navigator.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (selecteIds.isNotEmpty) ...[
          Themes.spacer,
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: selecteIds.map((int? id) => _buildPreview(id)).toList(),
            ),
          ),
        ],
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
            onItemRemoved?.call(id);
          },
          child: Icon(
            Icons.close_rounded,
            color: ShelflessColors.error,
          ),
        ),
      ],
    );
  }
}
