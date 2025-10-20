import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';

import 'package:shelfless/dialogs/error_dialog.dart';
import 'package:shelfless/models/book.dart';
import 'package:shelfless/models/raw_book.dart';
import 'package:shelfless/providers/library_content_provider.dart';
import 'package:shelfless/screens/crop_cover_screen.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/config.dart';
import 'package:shelfless/utils/constants.dart';
import 'package:shelfless/utils/shared_prefs_helper.dart';
import 'package:shelfless/utils/shared_prefs_keys.dart';
import 'package:shelfless/utils/strings/strings.dart';
import 'package:shelfless/widgets/authors_selection_widget.dart';
import 'package:shelfless/widgets/book_cover_image_widget.dart';
import 'package:shelfless/dialogs/double_choice_dialog.dart';
import 'package:shelfless/widgets/edit_section_widget.dart';
import 'package:shelfless/widgets/genres_selection_widget.dart';
import 'package:shelfless/widgets/slippery_text_form_field_widget.dart';
import 'package:shelfless/widgets/location_selection_widget.dart';
import 'package:shelfless/widgets/publisher_selection_widget.dart';

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

    LibraryContentProvider.instance.addListener(_onContentChanged);

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
  void dispose() {
    LibraryContentProvider.instance.removeListener(_onContentChanged);

    super.dispose();
  }

  void _onContentChanged() {
    if (context.mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Fetch providers.
    const double dialogWidth = 300.0;

    final int currentYear = DateTime.now().year;

    final EdgeInsets devicePadding = MediaQuery.paddingOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("${_inserting ? strings.insertTitle : strings.editTitle} ${strings.bookTitle}"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title.
                  EditSectionWidget(
                    spacing: Themes.spacingMedium,
                    children: [
                      Text(strings.bookInfoTitle),
                      SlipperyTextFormFieldWidget(
                        initialValue: widget.book?.raw.title,
                        onChanged: (String value) => _book.raw.title = value,
                        textCapitalization:
                            TextCapitalization.values[SharedPrefsHelper.instance.data.getInt(SharedPrefsKeys.titlesCapitalization) ?? Config.defaultTitlesCapitalization.index],
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
                              width: Themes.thumbnailSizeLarge,
                              height: Themes.thumbnailSizeLarge,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Themes.radiusMedium),
                                  child: BookCoverImageWidget(
                                    book: _book,
                                    child: Card(
                                      color: ShelflessColors.mainContentActive,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(Themes.spacingSmall),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            spacing: Themes.spacingSmall,
                                            children: [
                                              Icon(Icons.image_rounded),
                                              Text(
                                                strings.bookInfoNoImageSelected,
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
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
                                  style: IconButton.styleFrom(backgroundColor: ShelflessColors.errorLight),
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
                    inSelectedIds: {..._book.authorIds},
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
                    spacing: Themes.spacingMedium,
                    children: [
                      Text(strings.bookInfoPublishYear),
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

                  // Acquisition date.
                  EditSectionWidget(
                    spacing: Themes.spacingMedium,
                    children: [
                      Text(strings.bookInfoDateAcquired),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _book.raw.dateAcquired ?? DateTime.now(),
                            firstDate: DateTime(currentYear - Config.pastBookDateThreshold),
                            lastDate: DateTime(currentYear + Config.futureBookDateThreshold),
                          );

                          if (pickedDate == null) return;

                          setState(() {
                            _book.raw.dateAcquired = pickedDate;
                          });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: ShelflessColors.mainContentActive,
                            child: Padding(
                              padding: const EdgeInsets.all(Themes.spacingMedium),
                              child: Center(child: Text(_book.raw.dateAcquired != null ? DateFormat.yMd().format(_book.raw.dateAcquired!) : "-")),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Read date.
                  EditSectionWidget(
                    spacing: Themes.spacingMedium,
                    children: [
                      Text(strings.bookInfoDateRead),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _book.raw.dateRead ?? DateTime.now(),
                            firstDate: DateTime(currentYear - Config.pastBookDateThreshold),
                            lastDate: DateTime(currentYear + Config.futureBookDateThreshold),
                          );

                          if (pickedDate == null) return;

                          setState(() {
                            _book.raw.dateRead = pickedDate;
                          });
                        },
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            color: ShelflessColors.mainContentActive,
                            child: Padding(
                              padding: const EdgeInsets.all(Themes.spacingMedium),
                              child: Center(child: Text(_book.raw.dateRead != null ? DateFormat.yMd().format(_book.raw.dateRead!) : "-")),
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
                      setState(() {
                        _book.genreIds = selectedGenreIds.nonNulls.toList();
                      });
                    },
                    onGenreUnselected: (int genreId) {
                      setState(() {
                        _book.genreIds.remove(genreId);
                      });
                    },
                  ),

                  // Publisher.
                  PublisherSelectionWidget(
                    insertNew: true,
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

                  // Location.
                  LocationSelectionWidget(
                    insertNew: true,
                    selectedLocationId: _book.raw.locationId,
                    onLocationSelected: (int? locationId) {
                      // Make sure the locationId is not null.
                      if (locationId == null) return;

                      // Set the book location.
                      LibraryContentProvider.instance.addLocationToBook(locationId, _book);
                    },
                    onLocationUnselected: (int? locationId) {
                      LibraryContentProvider.instance.removeLocationFromBook(_book);
                    },
                  ),

                  // Notes.
                  EditSectionWidget(
                    spacing: Themes.spacingMedium,
                    children: [
                      Text(strings.bookInfoNotes),
                      SlipperyTextFormFieldWidget(
                        initialValue: widget.book?.raw.notes,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (String value) => _book.raw.notes = value,
                      ),
                    ],
                  ),

                  // Fab spacing.
                  SizedBox(height: fabAccessHeight + devicePadding.bottom),
                ],
              ),
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
    );
  }

  void _pickImage() async {
    if (!mounted) return;

    // Prefetch handlers before async gaps.
    final NavigatorState navigator = Navigator.of(context);

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
        firstOption: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Themes.spacingSmall,
          children: [
            Icon(
              Icons.camera_rounded,
              size: Themes.iconSizeLarge,
            ),
            Text(
              strings.imageSourceCamera,
            ),
          ],
        ),
        secondOption: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: Themes.spacingSmall,
          children: [
            Icon(
              Icons.camera_roll_rounded,
              size: Themes.iconSizeLarge,
            ),
            Text(strings.imageSourceGallery),
          ],
        ),
      ),
    );

    if (imageSource == null) return;

    // Pick file and make sure one is actually picked.
    final XFile? pickedFile = await ImagePicker().pickImage(source: imageSource);

    if (pickedFile == null) return;

    // Decode the file as image and make sure it is a known image format.
    Uint8List fileData = await pickedFile.readAsBytes();

    // Before actually returning the image, allow the user to correctly frame the image.
    final Uint8List? croppedImageData = await navigator.push(MaterialPageRoute(
      builder: (BuildContext context) => CropCoverScreen(
        image: Image.memory(fileData),
      ),
    ));

    // Just return if the operation was cancelled or for any reason no image was returned.
    if (croppedImageData == null) return;

    // Use the cropped image if possible.
    fileData = croppedImageData;

    img.Image? image;

    // Image decoding could generate errors, so catch exceptions and let the user know.
    try {
      image = img.decodeImage(fileData);
    } catch (exception) {
      image = null;
    }

    if (image == null) {
      if (mounted) {
        ErrorDialog(
          message: strings.imageReadErrorContent,
        ).show(context);
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
      _book.raw.cover = img.encodeBmp(resizedImage);
    });
  }
}
