import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/models/raw_book.dart';
import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/edit_publisher_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/authors_selection_widget.dart';
import 'package:shelfless/widgets/double_choice_dialog.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/genres_selection_widget.dart';
import 'package:shelfless/widgets/location_preview_widget.dart';
import 'package:shelfless/widgets/publisher_label_widget.dart';
import 'package:shelfless/widgets/publisher_selection_widget.dart';
import 'package:shelfless/widgets/search_list_widget.dart';
import 'package:shelfless/widgets/dialog_button_widget.dart';
import 'package:shelfless/widgets/selection_widget/multiple_selection_widget.dart';
import 'package:shelfless/widgets/unfocus_widget.dart';
import 'package:shelfless/widgets/unreleased_feature_dialog.dart';
import 'package:shelfless/widgets/unreleased_feature_widget.dart';

class EditBookScreen extends StatefulWidget {
  static const String routeName = "/edit-book";

  final Book? book;
  final void Function(Book book)? onDone;

  const EditBookScreen({
    super.key,
    this.book,
    this.onDone,
  });

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

    LibraryContentProvider.instance.addListener(() {
      if (context.mounted) setState(() {});
    });

    _inserting = widget.book == null;

    // The book is copied in order not to edit the original one by mistake.
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
                  // Title.
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

                  // Cover.
                  EditSectionWidget(
                    spacing: Themes.spacingMedium,
                    children: [
                      Text(strings.bookInfoCover),
                      Center(
                        child: Stack(
                          children: [
                            SizedBox(
                              width: Themes.thumbnailSizeMedium,
                              height: Themes.thumbnailSizeMedium,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: _book.raw.cover != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(Themes.radiusMedium),
                                        child: Image.memory(
                                          _book.raw.cover!,
                                          fit: BoxFit.cover,
                                          isAntiAlias: false,
                                          filterQuality: FilterQuality.none,
                                        ),
                                      )
                                    : Card(
                                        color: ShelflessColors.mainContentActive,
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            spacing: Themes.spacingSmall,
                                            children: [
                                              Icon(Icons.image_rounded),
                                              Text(strings.bookInfoNoImageSelected),
                                            ],
                                          ),
                                        ),
                                      ),
                              ),
                            ),

                            // Only show the remove cover button if a cover is actually selected.
                            if (_book.raw.cover != null)
                              Positioned(
                                top: Themes.spacingSmall,
                                right: Themes.spacingSmall,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _book.raw.cover = null;
                                    });
                                  },
                                  style: IconButton.styleFrom(backgroundColor: ShelflessColors.error),
                                  icon: Icon(Icons.close_rounded),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(strings.coverDescription),
                    ],
                  ),

                  // Authors.
                  AuthorsSelectionWidget(
                    inSelectedIds: _book.authorIds,
                    insertNew: true,
                    onAuthorsSelected: (Set<int?> selectedAuthorIds) {
                      setState(() {
                        _book.authorIds = selectedAuthorIds.nonNulls.toList();
                      });
                    },
                    onAuthorUnselected: (int authorId) {
                      setState(() {
                        _book.authorIds.remove(authorId);
                      });
                    },
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
                            color: ShelflessColors.mainContentActive,
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
                  GenresSelectionWidget(
                    inSelectedIds: _book.genreIds,
                    insertNew: true,
                    onGenresSelected: (Set<int?> selectedGenreIds) {
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
                    },
                    onGenreUnselected: (int genreId) {
                      // It's not strictly needed to call LibraryContentProvider to update the UI here, since working on the same object ensures
                      // consistency and not calling the provider allows the current widget to be the only one rebuilt by the state update.
                      setState(() {
                        _book.genreIds.remove(genreId);
                      });
                    },
                  ),

                  // Publisher.
                  PublisherSelectionWidget(
                    insertNew: true,
                    selectedPublisherId: _book.raw.publisherId,
                    onPublisherSelected: (int? publisherId) {
                      // Make sure the publisherId is not null.
                      if (publisherId == null) return;

                      // Set the book publisher.
                      LibraryContentProvider.instance.addPublisherToBook(publisherId, _book);
                    },
                    onPublisherUnselected: (int? publisherId) {
                      LibraryContentProvider.instance.removePublisherFromBook(_book);
                    },
                  ),
                  // EditSectionWidget(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(strings.bookInfoPublisher),
                  //         if (_book.raw.publisherId == null)
                  //           DialogButtonWidget(
                  //             label: Text(strings.select),
                  //             title: Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text(strings.publishers),
                  //                 TextButton(
                  //                   onPressed: () {
                  //                     Navigator.of(context).push(MaterialPageRoute(
                  //                       builder: (BuildContext context) => EditPublisherScreen(),
                  //                     ));
                  //                   },
                  //                   child: Text(strings.add),
                  //                 ),
                  //               ],
                  //             ),
                  //             content: StatefulBuilder(
                  //               builder: (BuildContext context, void Function(void Function()) setState) {
                  //                 LibraryContentProvider.instance.addListener(() {
                  //                   if (context.mounted) setState(() {});
                  //                 });

                  //                 return SearchListWidget<int?>(
                  //                   values: LibraryContentProvider.instance.publishers.keys.toList(),
                  //                   filter: (int? publisherId, String? filter) => filter != null ? publisherId.toString().toLowerCase().contains(filter) : true,
                  //                   builder: (int? publisherId) {
                  //                     final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

                  //                     if (publisher == null) return Placeholder();

                  //                     return GestureDetector(
                  //                       onTap: () {
                  //                         // Make sure the publisherId is not null.
                  //                         if (publisherId == null) return;

                  //                         // Set the book publisher.
                  //                         LibraryContentProvider.instance.addPublisherToBook(publisherId, _book);
                  //                         Navigator.of(context).pop();
                  //                       },
                  //                       child: PublisherLabelWidget(publisher: publisher),
                  //                     );
                  //                   },
                  //                 );
                  //               },
                  //             ),
                  //           ),
                  //       ],
                  //     ),
                  //     if (_book.raw.publisherId != null)
                  //       Column(
                  //         children: [
                  //           Themes.spacer,
                  //           Padding(
                  //             padding: const EdgeInsets.all(12.0),
                  //             child: _buildPublisherPreview(_book.raw.publisherId!),
                  //           ),
                  //         ],
                  //       ),
                  //   ],
                  // ),

                  // Location.
                  UnreleasedFeatureWidget(
                    child: EditSectionWidget(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(strings.bookInfoLocation),
                            if (_book.raw.locationId == null)
                              DialogButtonWidget(
                                label: Text(strings.select),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(strings.locations),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) => EditPublisherScreen(),
                                        ));
                                      },
                                      child: Text(strings.add),
                                    ),
                                  ],
                                ),
                                content: StatefulBuilder(
                                  builder: (BuildContext context, void Function(void Function()) setState) {
                                    LibraryContentProvider.instance.addListener(() {
                                      if (context.mounted) setState(() {});
                                    });

                                    return SearchListWidget<int?>(
                                      values: LibraryContentProvider.instance.locations.keys.toList(),
                                      filter: (int? locationId, String? filter) => filter != null ? locationId.toString().toLowerCase().contains(filter) : true,
                                      builder: (int? locationId) {
                                        final StoreLocation? location = LibraryContentProvider.instance.locations[locationId];

                                        if (location == null) return Placeholder();

                                        return LocationPreviewWidget(
                                          location: location,
                                          // onTap: () {
                                          //   // Make sure the publisherId is not null.
                                          //   if (locationId == null) return;

                                          //   // Set the book location.
                                          //   LibraryContentProvider.instance.addPublisherToBook(locationId, _book);
                                          //   Navigator.of(context).pop();
                                          // },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),
                        if (_book.raw.locationId != null)
                          Column(
                            children: [
                              Themes.spacer,
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: _buildPublisherPreview(_book.raw.locationId!),
                              ),
                            ],
                          ),
                      ],
                    ),
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

            widget.onDone?.call(_book);

            // Actually save the book by upsert.
            _inserting ? LibraryContentProvider.instance.storeNewBook(_book) : LibraryContentProvider.instance.storeBookUpdate(_book);

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

  Widget _buildPublisherPreview(int publisherId) {
    final Publisher? publisher = LibraryContentProvider.instance.publishers[publisherId];

    if (publisher == null) return Placeholder();

    return _buildPreview(
      PublisherLabelWidget(publisher: publisher),
      onDelete: () {
        // It's not strictly needed to call LibraryContentProvider to update the UI here, since working on the same object ensures
        // consistency and not calling the provider allows the current widget to be the only one rebuilt by the state update.
        setState(() {
          _book.raw.publisherId = null;
        });
      },
    );
  }

  Widget _buildLocationPreview(StoreLocation location) => _buildPreview(
        LocationPreviewWidget(location: location),
        onDelete: () {
          setState(() {
            _book.raw.locationId = null;
          });
        },
      );

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

  void _pickImage() async {
    if (!mounted) return;

    // Let the user select the image source.
    ImageSource? imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => DoubleChoiceDialog(
        title: Text(strings.imageSourceTitle),
        onFirstOptionSelected: () {
          Navigator.of(context).pop(ImageSource.camera);
        },
        onSecondOptionSelected: () {
          Navigator.of(context).pop(ImageSource.gallery);
        },
        firstOption: Text(strings.imageSourceCamera),
        secondOption: Text(strings.imageSourceGallery),
      ),
    );

    if (imageSource == null) return;

    // Pick file and make sure one is actually picked.
    // TODO Before actually returning the image, allow the user to correctly frame the image.
    final XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile == null) return;

    // Decode the file as image and make sure it is a known image format.
    final Uint8List fileData = await pickedFile.readAsBytes();

    img.Image? image;

    // Image decoding could generate errors, so catch exceptions and let the user know.
    try {
      image = img.decodeImage(fileData);
    } catch (exception) {
      image = null;
    }

    if (image == null) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(strings.genericError),
            content: Text("Something went wrong while reading your image, try and pick another one."),
          ),
        );
      }
      return;
    }

    // Resize the image to thumbnail size.
    final img.Image resizedImage = img.copyResizeCropSquare(
      image,
      size: 16,
      interpolation: img.Interpolation.nearest,
      antialias: false,
    );

    setState(() {
      _book.raw.cover = img.encodeJpg(resizedImage);
    });
  }
}
