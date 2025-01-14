
import 'package:flutter/material.dart';
import 'package:shelfless/models/publisher.dart';

import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/genre_preview_widget.dart';
import 'package:shelfless/widgets/publisher_preview_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

class PublishersSelectionWidget extends StatelessWidget {
  final List<int?> publisherIds;
  final void Function(Set<int?> publisherId)? onPublishersAdded;
  final void Function(int publisherId)? onPublisherRemoved;

  PublishersSelectionWidget({
    super.key,
    List<int?>? inPublisherIds,
    this.onPublishersAdded,
    this.onPublisherRemoved,
  }) : publisherIds = inPublisherIds ?? [];

  @override
  Widget build(BuildContext context) {
    return EditSectionWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.bookInfoPublishers),
            DialogButtonWidget(
              label: const Icon(Icons.add_rounded),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(strings.bookInfoPublishers),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => EditGenreScreen(),
                      ));
                    },
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
                    children: LibraryContentProvider.instance.publishers.keys.toList(),
                    multiple: true,
                    filter: (int? publisherId, String? filter) => filter != null ? LibraryContentProvider.instance.genres[publisherId].toString().toLowerCase().contains(filter) : true,
                    builder: (int? publisherId) {
                      final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

                      if (publisher == null) {
                        return Placeholder();
                      }

                      return PublisherPreviewWidget(publisher: publisher);
                    },
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onElementsSelected: (Set<int?> selectedGenreIds) {
                      final NavigatorState navigator = Navigator.of(context);

                      onPublishersAdded?.call(selectedGenreIds);

                      navigator.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (publisherIds.isNotEmpty)
          Column(
            children: [
              Themes.spacer,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: publisherIds.map((int? genreId) => _buildPublisherPreview(genreId)).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPublisherPreview(int? publisherId) {
    if (publisherId == null) return Placeholder();

    final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

    if (publisher == null) return Placeholder();

    return _buildPreview(
      PublisherPreviewWidget(publisher: publisher),
      onDelete: () {
        onPublisherRemoved?.call(publisherId);
      },
    );
  }

  Widget _buildPreview(Widget child, {void Function()? onDelete}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: child,
        ),
        TextButton(
          onPressed: () {
            onDelete?.call();
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