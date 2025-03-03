import 'dart:math';

import 'package:flutter/material.dart';

import 'package:blur/blur.dart';

import 'package:shelfless/models/book.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/material_utils.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/book_thumbnail_widget.dart';

class BookDetailsWidget extends StatelessWidget {
  final Book book;

  const BookDetailsWidget({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final EdgeInsets devicePadding = MediaQuery.paddingOf(context);
    final Size deviceSize = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        if (book.raw.cover != null)
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [
                  0.25,
                  1.0,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.dstOut,
            child: Blur(
              blur: Themes.blurStrengthHigh,
              colorOpacity: Themes.blurOpacity,
              blurColor: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                child: Image.memory(
                  book.raw.cover!,
                  fit: BoxFit.cover,
                  isAntiAlias: false,
                  filterQuality: FilterQuality.none,
                ),
              ),
            ),
          ),
        Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            physics: Themes.scrollPhysics,
            child: SizedBox(
              width: min(deviceSize.width, Themes.maxContentWidth),
              child: Column(
                spacing: Themes.spacingMedium,
                children: [
                  // Cover.
                  Column(
                    spacing: Themes.spacingXLarge,
                    children: [
                      // Top padding.
                      SizedBox(
                        height: devicePadding.top,
                      ),
                      Center(
                        child: BookThumbnailWidget(
                          book: book,
                          showOutBanner: true,
                        ),
                      ),
                    ],
                  ),

                  // Title, edition, publisher and publication year.
                  Column(
                    spacing: Themes.spacingSmall,
                    children: [
                      // TItle.
                      Center(
                        child: Text(
                          book.raw.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // TODO Edition.

                      // Publisher.
                      if (LibraryContentProvider.instance.publishers[book.raw.publisherId] != null)
                        Center(
                          child: Text("${LibraryContentProvider.instance.publishers[book.raw.publisherId]!}"),
                        ),

                      // Publication year.
                      Center(
                        child: Text(
                          "${book.raw.publishYear}",
                        ),
                      ),
                    ],
                  ),

                  // Authors and genres.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Authors.
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(Themes.spacingLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.authorsSectionTitle,
                                style: TextStyle(
                                  color: ShelflessColors.onMainContentInactive,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(Themes.spacingMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: Themes.spacingSmall,
                                  children: book.authorIds.map((int authorId) => Text(LibraryContentProvider.instance.authors[authorId].toString())).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Genres.
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(Themes.spacingLarge),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                strings.genresSectionTitle,
                                style: TextStyle(
                                  color: ShelflessColors.onMainContentInactive,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(Themes.spacingMedium),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  spacing: Themes.spacingSmall,
                                  children: book.genreIds.map((int genreId) => Text(LibraryContentProvider.instance.genres[genreId].toString())).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Actions.
                  Padding(
                    padding: const EdgeInsets.all(Themes.spacingMedium),
                    child: Row(
                      spacing: Themes.spacingSmall,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildAction(
                            context,
                            onPressed: () {
                              // Update book and store the update in DB.
                              book.raw.out = !book.raw.out;

                              LibraryContentProvider.instance.storeBookUpdate(book);
                            },
                            label: book.raw.out ? strings.bookMarkInAction : strings.bookMarkOutAction,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildAction(
                            context,
                            onPressed: () {
                              MaterialUtils.moveBookTo(context, book: book);
                            },
                            label: strings.bookMoveTo,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Location.
                  if (book.raw.locationId != null)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(Themes.spacingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: Themes.spacingSmall,
                          children: [
                            Text(
                              strings.locationTitle,
                              style: TextStyle(
                                color: ShelflessColors.onMainContentInactive,
                              ),
                            ),
                            Text("${LibraryContentProvider.instance.locations[book.raw.locationId]}"),
                          ],
                        ),
                      ),
                    ),

                  // Notes.
                  if (book.raw.notes.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(Themes.spacingMedium),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: Themes.spacingSmall,
                          children: [
                            Text(
                              strings.bookInfoNotes,
                              style: TextStyle(
                                color: ShelflessColors.onMainContentInactive,
                              ),
                            ),
                            Text(
                              book.raw.notes,
                              maxLines: null,
                              textAlign: TextAlign.justify,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAction(
    BuildContext context, {
    void Function()? onPressed,
    required String label,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: ShelflessColors.onMainContentActive,
        backgroundColor: ShelflessColors.mainContentInactive,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Themes.spacingMedium),
        child: Text(
          label,
          maxLines: 1,
        ),
      ),
    );
  }
}
