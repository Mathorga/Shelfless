import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/publisher.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/providers/libraries_provider.dart';
import 'package:shelfish/providers/publishers_provider.dart';
import 'package:shelfish/providers/store_locations_provider.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/edit_location_screen.dart';
import 'package:shelfish/screens/edit_publisher_screen.dart';
import 'package:shelfish/themes/shelfless_colors.dart';
import 'package:shelfish/utils/constants.dart';
import 'package:shelfish/utils/strings/strings.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';
import 'package:shelfish/widgets/location_preview_widget.dart';
import 'package:shelfish/widgets/publisher_preview_widget.dart';
import 'package:shelfish/widgets/search_list_widget.dart';
import 'package:shelfish/widgets/dialog_button_widget.dart';
import 'package:shelfish/widgets/separator_widget.dart';
import 'package:shelfish/widgets/unfocus_widget.dart';

class EditBookScreen extends StatefulWidget {
  static const String routeName = "/edit-book";

  const EditBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final Box<Author> _authors = Hive.box<Author>("authors");
  final Box<Genre> _genres = Hive.box<Genre>("genres");

  late Book _book;

  // Insert flag: tells whether the widget is used for adding or editing a book.
  bool _inserting = true;

  @override
  void initState() {
    super.initState();

    _book = Book(
      authors: HiveList(_authors),
      genres: HiveList(_genres),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch providers.
    final BooksProvider _booksProvider = Provider.of(context, listen: false);
    final LibrariesProvider _librariesProvider = Provider.of(context, listen: false);

    // Fetch passed arguments.
    Book? receivedBook = ModalRoute.of(context)!.settings.arguments as Book?;
    _inserting = receivedBook == null;

    const double dialogWidth = 300.0;

    if (!_inserting) {
      _book = receivedBook!;
    }

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
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(strings.bookInfoTitle),
                TextFormField(
                  initialValue: _book.title,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (String value) => _book.title = value,
                ),

                const SeparatorWidget(
                  child: Divider(
                    height: 2.0,
                  ),
                ),

                // Authors.
                Text(strings.bookInfoAuthors),
                if (_book.authors.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _book.authors.map((Author author) => _buildAuthorPreview(author)).toList(),
                    ),
                  ),

                DialogButtonWidget(
                  label: const Icon(Icons.add_rounded),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(strings.bookInfoAuthors),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(EditAuthorScreen.routeName);
                        },
                        child: Text(strings.add),
                      ),
                    ],
                  ),
                  content: Consumer<AuthorsProvider>(
                    builder: (BuildContext context, AuthorsProvider provider, Widget? child) => SearchListWidget<Author>(
                      children: provider.authors,
                      filter: (Author author, String? filter) => filter != null ? author.toString().toLowerCase().contains(filter) : true,
                      builder: (Author author) => GestureDetector(
                        onTap: () {
                          // Only add the author if not already there.
                          if (!_book.authors.contains(author)) {
                            setState(() {
                              _book.authors.add(author);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(strings.authorAlreadyAdded),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          Navigator.of(context).pop();
                        },
                        child: AuthorPreviewWidget(
                          author: author,
                          live: false,
                        ),
                      ),
                    ),
                  ),
                ),

                const SeparatorWidget(
                  child: Divider(
                    height: 2.0,
                  ),
                ),

                // Publish year.
                Text(strings.bookInfoPublishDate),
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
                            selectedDate: DateTime(currentYear),
                            onChanged: (DateTime value) {
                              Navigator.of(context).pop();
                              setState(() {
                                _book.publishDate = value.year;
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text((_book.publishDate).toString()),
                    ),
                  ),
                ),

                const SeparatorWidget(
                  child: Divider(
                    height: 2.0,
                  ),
                ),

                // Genres.
                Text(strings.bookInfoGenres),
                if (_book.genres.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _book.genres.map((Genre genre) => _buildGenrePreview(genre)).toList(),
                    ),
                  ),

                DialogButtonWidget(
                  label: const Icon(Icons.add_rounded),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(strings.bookInfoGenres),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(EditGenreScreen.routeName);
                        },
                        child: Text(strings.add),
                      ),
                    ],
                  ),
                  content: Consumer<GenresProvider>(
                    builder: (BuildContext context, GenresProvider provider, Widget? child) => SearchListWidget<Genre>(
                      children: provider.genres,
                      filter: (Genre genre, String? filter) => filter != null ? genre.toString().toLowerCase().contains(filter) : true,
                      builder: (Genre genre) => GestureDetector(
                        onTap: () {
                          // Only add the author if not already there.
                          if (!_book.genres.contains(genre)) {
                            setState(() {
                              _book.genres.add(genre);
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(strings.authorAlreadyAdded),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          Navigator.of(context).pop();
                        },
                        child: GenrePreviewWidget(genre: genre),
                      ),
                    ),
                  ),
                ),

                const SeparatorWidget(
                  child: Divider(
                    height: 2.0,
                  ),
                ),

                // Publisher.
                Text(strings.bookInfoPublisher),
                if (_book.publisher != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildPublisherPreview(_book.publisher!),
                  ),

                if (_book.publisher == null)
                  DialogButtonWidget(
                    label: Text(strings.select),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(strings.publishers),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(EditPublisherScreen.routeName);
                          },
                          child: Text(strings.add),
                        ),
                      ],
                    ),
                    content: Consumer<PublishersProvider>(
                      builder: (BuildContext context, PublishersProvider provider, Widget? child) => SearchListWidget<Publisher>(
                        children: provider.publishers,
                        filter: (Publisher publisher, String? filter) => filter != null ? publisher.toString().toLowerCase().contains(filter) : true,
                        builder: (Publisher publisher) => ListTile(
                          leading: Text(publisher.name),
                          onTap: () {
                            // Set the book location.
                            setState(() {
                              _book.publisher = publisher;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),

                const SeparatorWidget(
                  child: Divider(
                    height: 2.0,
                  ),
                ),

                // Location.
                Text(strings.bookInfoLocation),
                if (_book.location != null)
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildLocationPreview(_book.location!),
                  ),

                if (_book.location == null)
                  DialogButtonWidget(
                    label: Text(strings.select),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(strings.locations),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(EditLocationScreen.routeName);
                          },
                          child: Text(strings.add),
                        ),
                      ],
                    ),
                    content: Consumer<StoreLocationsProvider>(
                      builder: (BuildContext context, StoreLocationsProvider provider, Widget? child) => SearchListWidget<StoreLocation>(
                        children: provider.locations,
                        filter: (StoreLocation location, String? filter) => filter != null ? location.toString().toLowerCase().contains(filter) : true,
                        builder: (StoreLocation location) => ListTile(
                          leading: Text(location.name),
                          onTap: () {
                            // Set the book location.
                            setState(() {
                              _book.location = location;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: fabAccessHeight),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (_book.title != "" && _book.authors.isNotEmpty && _book.genres.isNotEmpty) {
              // Actually save the book.
              if (_inserting) {
                _booksProvider.addBook(_book);
                _librariesProvider.addBookToCurrentLibrary(_book);
              } else {
                _booksProvider.updateBook(_book);
              }

              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(strings.bookErrorNoTitleProvided),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
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

  Widget _buildAuthorPreview(Author author) => _buildPreview(
        AuthorPreviewWidget(
          author: author,
          live: false,
        ),
        onDelete: () {
          setState(() {
            _book.authors.remove(author);
          });
        },
      );

  Widget _buildGenrePreview(Genre genre) => _buildPreview(
        GenrePreviewWidget(genre: genre),
        onDelete: () {
          setState(() {
            _book.genres.remove(genre);
          });
        },
      );

  Widget _buildPublisherPreview(Publisher publisher) => _buildPreview(
        PublisherPreviewWidget(publisher: publisher),
        onDelete: () {
          setState(() {
            _book.publisher = null;
          });
        },
      );

  Widget _buildLocationPreview(StoreLocation location) => _buildPreview(
        LocationPreviewWidget(location: location),
        onDelete: () {
          _book.location = null;
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
            // setState(() {
            //   _book.location = null;
            // });
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
