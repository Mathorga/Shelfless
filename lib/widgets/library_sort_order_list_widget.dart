import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';

class LibrarySortOrderListWidget extends StatefulWidget {
  const LibrarySortOrderListWidget({super.key});

  @override
  State<LibrarySortOrderListWidget> createState() => _LibrarySortOrderListWidgetState();
}

class _LibrarySortOrderListWidgetState extends State<LibrarySortOrderListWidget> {
  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    LibraryContentProvider.instance.removeListener(_onContentChanged);

    super.dispose();
  }

  void _onContentChanged() {
    if (context.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(Themes.spacingMedium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title.
          Text(
            strings.librarySortBy,
            style: theme.textTheme.headlineSmall,
          ),
          RadioGroup<int>(
            groupValue: LibraryContentProvider.instance.sortOrder.index,
            onChanged: (int? value) {
              // Just return if null is received.
              if (value == null) return;

              // Set the new value otherwise.
              LibraryContentProvider.instance.sortBooksBy(SortOrder.values[value]);
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: SortOrder.values
                    .where((SortOrder sortOrder) => sortOrder.enabled)
                    .mapIndexed(
                      (int index, SortOrder sortOrder) => GestureDetector(
                        onTap: () {
                          // Set the new value.
                          LibraryContentProvider.instance.sortBooksBy(sortOrder);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(sortOrder.label()),
                            ),
                            Radio<int>(value: index),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
