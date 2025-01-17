import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

class SelectionController extends ChangeNotifier {
  List<int?> sourceIds;

  SelectionController({
    this.sourceIds = const [],
  });

  void setIds(List<int?> ids) {
    sourceIds = ids;
    notifyListeners();
  }
}

class SelectionWidget extends StatelessWidget {
  final String? title;
  final SelectionController controller;
  final void Function()? onInsertNewRequested;
  final bool Function(int? id, String? filter) listItemsFilter;
  final Widget Function(int? id) listItemBuilder;
  // final List<int?> Function() getSourceIds;
  final List<int?> selecteIds;
  final void Function(Set<int?> ids)? onItemsSelected;
  final void Function(int id)? onItemUnselected;

  SelectionWidget({
    super.key,
    this.title,
    required this.controller,
    this.onInsertNewRequested,
    required this.listItemsFilter,
    required this.listItemBuilder,
    // required this.getSourceIds,
    List<int?>? inSelectedIds,
    this.onItemsSelected,
    this.onItemUnselected,
  }) : selecteIds = inSelectedIds ?? [];

  @override
  Widget build(BuildContext context) {
    return EditSectionWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (title != null) Text(title!),
            DialogButtonWidget(
              label: const Icon(Icons.add_rounded),
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
                builder: (BuildContext context, void Function(void Function()) setState) {
                  // Make sure updates are reacted to.
                  controller.addListener(() {
                    if (context.mounted) setState(() {});
                  });

                  return SearchListWidget<int?>(
                    children: controller.sourceIds,
                    multiple: true,
                    filter: listItemsFilter,
                    builder: listItemBuilder,
                    onElementsSelected: (Set<int?> selectedIds) {
                      // Prefetch handlers.
                      final NavigatorState navigator = Navigator.of(context);

                      onItemsSelected?.call(selectedIds);

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
            onItemUnselected?.call(id);
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