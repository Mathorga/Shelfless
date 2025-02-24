import 'package:flutter/material.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/themes.dart';

class LibrarySortOrderListWidget extends StatefulWidget {
  const LibrarySortOrderListWidget({super.key});

  @override
  State<LibrarySortOrderListWidget> createState() => _LibrarySortOrderListWidgetState();
}

class _LibrarySortOrderListWidgetState extends State<LibrarySortOrderListWidget> {
  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() {
      if (context.mounted) {
        setState(() {});
      }
    });
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
            "Sort by",
            style: theme.textTheme.headlineSmall,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Themes.spacingMedium,
              children: SortOrder.values
                  .where((SortOrder sortOrder) => sortOrder.enabled)
                  .map(
                    (SortOrder sortOrder) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sortOrder.label(),
                        ),
                        Radio(
                          value: LibraryContentProvider.instance.sortOrder == sortOrder,
                          groupValue: true,
                          onChanged: (bool? value) => LibraryContentProvider.instance.sortBooksBy(sortOrder),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
