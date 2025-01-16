import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_preview_widget.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';

class AuthorsSelectionWidget extends StatelessWidget {
  final List<int?> selectedAuthorIds;
  final void Function(Set<int?> authorIds)? onAuthorsAdded;
  final void Function(int authorId)? onAuthorRemoved;
  final bool insertNew;

  AuthorsSelectionWidget({
    super.key,
    List<int?>? inAuthorIds,
    this.onAuthorsAdded,
    this.onAuthorRemoved,
    this.insertNew = false,
  }) : selectedAuthorIds = inAuthorIds ?? [];

  @override
  Widget build(BuildContext context) {
    return EditSectionWidget(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(strings.bookInfoAuthors),
            DialogButtonWidget(
              label: const Icon(Icons.add_rounded),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(strings.bookInfoAuthors),
                  if (insertNew)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => const EditAuthorScreen(),
                          ),
                        );
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
                    children: LibraryContentProvider.instance.authors.keys.toList(),
                    multiple: true,
                    filter: (int? authorId, String? filter) => filter != null ? LibraryContentProvider.instance.authors[authorId].toString().toLowerCase().contains(filter) : true,
                    builder: (int? authorId) {
                      final Author? author = LibraryContentProvider.instance.authors[authorId];

                      if (author == null) {
                        return Placeholder();
                      }

                      return AuthorPreviewWidget(author: author);
                    },
                    onElementsSelected: (Set<int?> selectedAuthorIds) {
                      // Prefetch handlers.
                      final NavigatorState navigator = Navigator.of(context);

                      onAuthorsAdded?.call(selectedAuthorIds);

                      navigator.pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
        if (selectedAuthorIds.isNotEmpty)
          Column(
            children: [
              Themes.spacer,
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: selectedAuthorIds.map((int? authorId) => _buildAuthorPreview(authorId)).toList(),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAuthorPreview(int? authorId) {
    if (authorId == null) return Placeholder();

    final Author? author = LibraryContentProvider.instance.authors[authorId];

    if (author == null) return Placeholder();

    return _buildPreview(
      AuthorPreviewWidget(author: author),
      onDelete: () {
        onAuthorRemoved?.call(authorId);
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
