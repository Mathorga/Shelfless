import 'package:flutter/material.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/raw_book.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_author_screen.dart';
import 'package:shelfless/screens/edit_genre_screen.dart';
import 'package:shelfless/screens/edit_location_screen.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/author_preview_widget.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/genre_preview_widget.dart';
import 'package:shelfless/widgets/location_preview_widget.dart';
import 'package:shelfless/widgets/publisher_preview_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';

class EditBookScreen extends StatefulWidget {
  static const String routeName = "/edit-book";

  final Book? book;

  const EditBookScreen({
    Key? key,
    this.book,
  }) : super(key: key);

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late Book _book;

  // Insert flag: tells whether the widget is used for adding or editing a book.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    LibraryContentProvider.instance.addListener(() => setState(() {}));

    _inserting = widget.book == null;

    _book = widget.book != null
        ? widget.book!.copy()
        : Book(
            raw: RawBook(
              libraryId: LibraryContentProvider.instance.library?.id,
              publishYear: DateTime.now().year,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch providers.
    const double dialogWidth = 300.0;

    final int currentYear = DateTime.now().year;

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.bookTitle}"),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  EditSectionWidget(
                    children: [
                      Text(strings.bookInfoTitle),
                      Themes.spacer,
                      TextFormField(
                        initialValue: _book.raw.title,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (String value) => _book.raw.title = value,
                      ),
                    ],
                  ),

                  // Authors.
                  EditSectionWidget(
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
                                LibraryContentProvider.instance.addListener(() => setState(() {}));

                                return SearchListWidget<int?>(
                                  children: LibraryContentProvider.instance.authors.keys.toList(),
                                  multiple: true,
                                  filter: (int? authorId, String? filter) =>
                                      filter != null ? LibraryContentProvider.instance.authors[authorId].toString().toLowerCase().contains(filter) : true,
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

                                    bool duplicates = false;
                                    Set<int> authorIds = {};
                                    for (int? authorId in selectedAuthorIds) {
                                      // Make sure the authorId is not null.
                                      if (authorId == null) continue;

                                      if (!_book.genreIds.contains(authorId)) {
                                        authorIds.add(authorId);
                                      } else {
                                        duplicates = true;
                                      }
                                    }

                                    if (duplicates) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(strings.authorAlreadyAdded),
                                          duration: const Duration(milliseconds: 1000),
                                        ),
                                      );
                                    }

                                    LibraryContentProvider.instance.addAuthorsToBook(authorIds, _book);

                                    navigator.pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_book.authorIds.isNotEmpty)
                        Column(
                          children: [
                            Themes.spacer,
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _book.authorIds.map((int authorId) => _buildAuthorPreview(authorId)).toList(),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  // Publish year.
                  EditSectionWidget(
                    children: [
                      Text(strings.bookInfoPublishDate),
                      Themes.spacer,
                      GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(strings.selectPublishYear),
                              content: SizedBox(
                                width: dialogWidth,
                                height: Themes.maxDialogHeight,
                                child: YearPicker(
                                  firstDate: DateTime(0),
                                  lastDate: DateTime(currentYear),
                                  selectedDate: DateTime(_book.raw.publishYear),
                                  currentDate: DateTime(_book.raw.publishYear),
                                  onChanged: (DateTime value) {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _book.raw.publishYear = value.year;
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(Themes.spacingMedium),
                              child: Center(child: Text((_book.raw.publishYear).toString())),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Genres.
                  EditSectionWidget(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(strings.bookInfoGenres),
                          DialogButtonWidget(
                            label: const Icon(Icons.add_rounded),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(strings.bookInfoGenres),
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
                                LibraryContentProvider.instance.addListener(() => setState(() {}));

                                return SearchListWidget<int?>(
                                  children: LibraryContentProvider.instance.genres.keys.toList(),
                                  multiple: true,
                                  filter: (int? genreId, String? filter) =>
                                      filter != null ? LibraryContentProvider.instance.genres[genreId].toString().toLowerCase().contains(filter) : true,
                                  builder: (int? genreId) {
                                    final RawGenre? rawGenre = LibraryContentProvider.instance.genres[genreId];

                                    if (rawGenre == null) {
                                      return Placeholder();
                                    }

                                    return GenrePreviewWidget(genre: rawGenre);
                                  },
                                  onElementsSelected: (Set<int?> selectedGenreIds) {
                                    // Prefetch handlers.
                                    final NavigatorState navigator = Navigator.of(context);

                                    bool duplicates = false;
                                    Set<int> genreIds = {};
                                    for (int? genreId in selectedGenreIds) {
                                      // Make sure the genreId is not null.
                                      if (genreId == null) continue;

                                      if (!_book.genreIds.contains(genreId)) {
                                        genreIds.add(genreId);
                                      } else {
                                        duplicates = true;
                                      }
                                    }

                                    if (duplicates) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(strings.genreAlreadyAdded),
                                          duration: const Duration(milliseconds: 1000),
                                        ),
                                      );
                                    }

                                    LibraryContentProvider.instance.addGenresToBook(genreIds, _book);

                                    navigator.pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      if (_book.genreIds.isNotEmpty)
                        Column(
                          children: [
                            Themes.spacer,
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: _book.genreIds.map((int genreId) => _buildGenrePreview(genreId)).toList(),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  // Publisher.
                  EditSectionWidget(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(strings.bookInfoPublisher),
                          if (_book.raw.publisherId == null)
                            DialogButtonWidget(
                              label: Text(strings.select),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(strings.publishers),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditPublisherScreen()));
                                    },
                                    child: Text(strings.add),
                                  ),
                                ],
                              ),
                              content: SearchListWidget<int?>(
                                children: LibraryContentProvider.instance.publishers.keys.toList(),
                                filter: (int? publisherId, String? filter) => filter != null ? publisherId.toString().toLowerCase().contains(filter) : true,
                                builder: (int? publisherId) {
                                  final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

                                  if (publisher == null) return Placeholder();

                                  return ListTile(
                                    leading: Text(publisher.name),
                                    onTap: () {
                                      // Make sure the publisherId is not null.
                                      if (publisherId == null) return;

                                      // Set the book location.
                                      LibraryContentProvider.instance.addPublisherToBook(publisherId, _book);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                      if (_book.raw.publisherId != null)
                        Column(
                          children: [
                            Themes.spacer,
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: _buildPublisherPreview(_book.raw.publisherId!),
                            ),
                          ],
                        ),
                    ],
                  ),

                  // Location.
                  EditSectionWidget(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(strings.bookInfoLocation),
                          // if (_book.locationId == null)
                          // DialogButtonWidget(
                          //   label: Text(strings.select),
                          //   title: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(strings.locations),
                          //       TextButton(
                          //         onPressed: () {
                          //           // Navigator.of(context).pushNamed(EditLocationScreen.routeName);
                          //         },
                          //         child: Text(strings.add),
                          //       ),
                          //     ],
                          //   ),
                          //   content: Consumer<StoreLocationsProvider>(
                          //     builder: (BuildContext context, StoreLocationsProvider provider, Widget? child) => SearchListWidget<StoreLocation>(
                          //       children: provider.locations,
                          //       filter: (StoreLocation location, String? filter) => filter != null ? location.toString().toLowerCase().contains(filter) : true,
                          //       builder: (StoreLocation location) => ListTile(
                          //         leading: Text(location.name),
                          //         onTap: () {
                          //           // Set the book location.
                          //           setState(() {
                          //             _book.location = location;
                          //           });
                          //           Navigator.of(context).pop();
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      // if (_book.location != null)
                      //   Column(
                      //     children: [
                      //       Themes.spacer,
                      //       Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: _buildLocationPreview(_book.location!),
                      //       ),
                      //     ],
                      //   ),
                    ],
                  ),

                  const SizedBox(height: fabAccessHeight),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Prefetch handlers before async gaps.
            final NavigatorState navigator = Navigator.of(context);

            if (_book.raw.title == "") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.bookErrorNoTitleProvided),
                  duration: const Duration(seconds: 2),
                ),
              );

              return;
            }

            if (_book.authorIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.bookErrorNoAuthorProvided),
                  duration: const Duration(seconds: 2),
                ),
              );

              return;
            }

            if (_book.genreIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.bookErrorNoGenreProvided),
                  duration: const Duration(seconds: 2),
                ),
              );

              return;
            }

            // Actually save the book.
            if (_inserting) {
              LibraryContentProvider.instance.storeNewBook(_book);
            } else {
              LibraryContentProvider.instance.storeBookUpdate(_book);
            }

            navigator.pop();
          },
          label: Row(
            children: [
              Text(strings.editDone),
              const SizedBox(width: 12.0),
              const Icon(Icons.check),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorPreview(int authorId) {
    final Author? author = LibraryContentProvider.instance.authors[authorId];

    if (author == null) return Placeholder();

    return _buildPreview(
      AuthorPreviewWidget(author: author),
      onDelete: () {
        // It's not strictly needed to call LibraryContentProvider to update the UI here, since working on the same object ensures
        // consistency and not calling the provider allows the current widget to be the only one rebuilt by the state update.
        setState(() {
          _book.authorIds.remove(authorId);
        });
      },
    );
  }

  Widget _buildGenrePreview(int genreId) {
    final RawGenre? rawGenre = LibraryContentProvider.instance.genres[genreId];

    if (rawGenre == null) return Placeholder();

    return _buildPreview(
      GenrePreviewWidget(genre: rawGenre),
      onDelete: () {
        // It's not strictly needed to call LibraryContentProvider to update the UI here, since working on the same object ensures
        // consistency and not calling the provider allows the current widget to be the only one rebuilt by the state update.
        setState(() {
          _book.genreIds.remove(genreId);
        });
      },
    );
  }

  Widget _buildPublisherPreview(int publisherId) {
    final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

    if (publisher == null) return Placeholder();

    return _buildPreview(
      PublisherPreviewWidget(publisher: publisher),
      onDelete: () {
        // It's not strictly needed to call LibraryContentProvider to update the UI here, since working on the same object ensures
        // consistency and not calling the provider allows the current widget to be the only one rebuilt by the state update.
        setState(() {
          _book.raw.publisherId = null;
        });
      },
    );
  }

  // Widget _buildLocationPreview(StoreLocation location) => _buildPreview(
  //       LocationPreviewWidget(location: location),
  //       onDelete: () {
  //         setState(() {
  //           _book.location = null;
  //         });
  //       },
  //     );

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
