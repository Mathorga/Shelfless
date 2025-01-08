import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shelfless/models/author.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/genre.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/libraries_provider.dart';
import 'package:shelfless/providers/library_provider.dart';
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

    _inserting = widget.book == null;

    _book = widget.book != null
        ? widget.book!.copy()
        : Book(
            libraryId: LibraryProvider.instance.library?.id,
            publishYear: DateTime.now().year,
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
                        initialValue: _book.title,
                        textCapitalization: TextCapitalization.words,
                        onChanged: (String value) => _book.title = value,
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
                          // DialogButtonWidget(
                          //   label: const Icon(Icons.add_rounded),
                          //   title: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(strings.bookInfoAuthors),
                          //       TextButton(
                          //         onPressed: () {
                          //           // Navigator.of(context).push(
                          //           //   MaterialPageRoute(
                          //           //     builder: (BuildContext context) => const EditAuthorScreen(),
                          //           //   ),
                          //           // );
                          //         },
                          //         child: Text(strings.add),
                          //       ),
                          //     ],
                          //   ),
                          //   content: Consumer<AuthorsProvider>(
                          //     builder: (BuildContext context, AuthorsProvider provider, Widget? child) => SearchListWidget<Author>(
                          //       children: provider.authors,
                          //       filter: (Author author, String? filter) => filter != null ? author.toString().toLowerCase().contains(filter) : true,
                          //       builder: (Author author) => GestureDetector(
                          //         onTap: () {
                          //           // Only add the author if not already there.
                          //           if (!_book.authors.contains(author)) {
                          //             setState(() {
                          //               _book.authors.add(author);
                          //             });
                          //           } else {
                          //             ScaffoldMessenger.of(context).showSnackBar(
                          //               SnackBar(
                          //                 content: Text(strings.authorAlreadyAdded),
                          //                 duration: const Duration(seconds: 2),
                          //               ),
                          //             );
                          //           }
                          //           Navigator.of(context).pop();
                          //         },
                          //         child: AuthorPreviewWidget(
                          //           author: author,
                          //           live: false,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      // if (_book.authorIds.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Themes.spacer,
                      //       Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.stretch,
                      //           children: _book.authors.map((Author author) => _buildAuthorPreview(author)).toList(),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
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
                                child: YearPicker(
                                  firstDate: DateTime(0),
                                  lastDate: DateTime(currentYear),
                                  selectedDate: DateTime(_book.publishYear),
                                  currentDate: DateTime(_book.publishYear),
                                  initialDate: DateTime(_book.publishYear),
                                  onChanged: (DateTime value) {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _book.publishYear = value.year;
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
                              child: Center(child: Text((_book.publishYear).toString())),
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
                          // DialogButtonWidget(
                          //   label: const Icon(Icons.add_rounded),
                          //   title: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Text(strings.bookInfoGenres),
                          //       TextButton(
                          //         onPressed: () {
                          //           // Navigator.of(context).pushNamed(EditGenreScreen.routeName);
                          //         },
                          //         child: Text(strings.add),
                          //       ),
                          //     ],
                          //   ),
                          //   content: Consumer<GenresProvider>(
                          //     builder: (BuildContext context, GenresProvider provider, Widget? child) => SearchListWidget<Genre>(
                          //       children: provider.genres,
                          //       multiple: true,
                          //       filter: (Genre genre, String? filter) => filter != null ? genre.toString().toLowerCase().contains(filter) : true,
                          //       builder: (Genre genre) => GenrePreviewWidget(genre: genre),
                          //       onElementsSelected: (Set<Genre> selectedGenres) {
                          //         // Prefetch handlers.
                          //         final NavigatorState navigator = Navigator.of(context);

                          //         bool duplicates = false;
                          //         for (Genre genre in selectedGenres) {
                          //           if (!_book.genres.contains(genre)) {
                          //             _book.genres.add(genre);
                          //           } else {
                          //             duplicates = true;
                          //           }
                          //         }

                          //         if (duplicates) {
                          //           ScaffoldMessenger.of(context).showSnackBar(
                          //             SnackBar(
                          //               content: Text(strings.authorAlreadyAdded),
                          //               duration: const Duration(milliseconds: 1000),
                          //             ),
                          //           );
                          //         }

                          //         setState(() {});

                          //         navigator.pop();
                          //       },
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      // if (_book.genreIds.isNotEmpty)
                      //   Column(
                      //     children: [
                      //       Themes.spacer,
                      //       Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.stretch,
                      //           children: _book.genres.map((Genre genre) => _buildGenrePreview(genre)).toList(),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                    ],
                  ),

                  // Publisher.
                  EditSectionWidget(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(strings.bookInfoPublisher),
                          // if (_book.publisherId == null)
                            // DialogButtonWidget(
                            //   label: Text(strings.select),
                            //   title: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(strings.publishers),
                            //       TextButton(
                            //         onPressed: () {
                            //           // Navigator.of(context).pushNamed(EditPublisherScreen.routeName);
                            //         },
                            //         child: Text(strings.add),
                            //       ),
                            //     ],
                            //   ),
                            //   content: Consumer<PublishersProvider>(
                            //     builder: (BuildContext context, PublishersProvider provider, Widget? child) => SearchListWidget<Publisher>(
                            //       children: provider.publishers,
                            //       filter: (Publisher publisher, String? filter) => filter != null ? publisher.toString().toLowerCase().contains(filter) : true,
                            //       builder: (Publisher publisher) => ListTile(
                            //         leading: Text(publisher.name),
                            //         onTap: () {
                            //           // Set the book location.
                            //           setState(() {
                            //             _book.publisher = publisher;
                            //           });
                            //           Navigator.of(context).pop();
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                        ],
                      ),
                      // if (_book.publisher != null)
                      //   Column(
                      //     children: [
                      //       Themes.spacer,
                      //       Padding(
                      //         padding: const EdgeInsets.all(12.0),
                      //         child: _buildPublisherPreview(_book.publisher!),
                      //       ),
                      //     ],
                      //   ),
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
            // if (_book.title != "" && _book.authors.isNotEmpty && _book.genres.isNotEmpty) {
            //   // Actually save the book.
            //   if (_inserting) {
            //     _booksProvider.addBook(_book);
            //     _librariesProvider.addBookToCurrentLibrary(_book);
            //   } else {
            //     _booksProvider.updateBook(widget.book!..copyFrom(_book));
            //   }

            //   Navigator.of(context).pop();
            // } else {
            //   ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text(strings.bookErrorNoTitleProvided),
            //       duration: const Duration(seconds: 2),
            //     ),
            //   );
            // }
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

  // Widget _buildAuthorPreview(Author author) => _buildPreview(
  //       AuthorPreviewWidget(
  //         author: author,
  //         live: false,
  //       ),
  //       onDelete: () {
  //         setState(() {
  //           _book.authors.remove(author);
  //         });
  //       },
  //     );

  // Widget _buildGenrePreview(Genre genre) => _buildPreview(
  //       GenrePreviewWidget(genre: genre),
  //       onDelete: () {
  //         setState(() {
  //           _book.genres.remove(genre);
  //         });
  //       },
  //     );

  // Widget _buildPublisherPreview(Publisher publisher) => _buildPreview(
  //       PublisherPreviewWidget(publisher: publisher),
  //       onDelete: () {
  //         setState(() {
  //           _book.publisher = null;
  //         });
  //       },
  //     );

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
