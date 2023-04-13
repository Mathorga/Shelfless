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
import 'package:shelfish/utils/constants.dart';
import 'package:shelfish/utils/strings/strings.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';
import 'package:shelfish/widgets/location_preview_widget.dart';
import 'package:shelfish/widgets/publisher_preview_widget.dart';
import 'package:shelfish/widgets/selector_widget.dart';
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

                SelectorWidget(
                  label: Text(strings.addOne),
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
                    // Listen to changes in saved authors.
                    builder: (BuildContext context, AuthorsProvider provider, Widget? child) => SizedBox(
                      width: dialogWidth,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ...provider.authors
                              .map((Author author) => GestureDetector(
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
                                    child: AuthorPreviewWidget(author: author),
                                  ))
                              .toList(),
                        ],
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

                SelectorWidget(
                    label: Text(strings.addOne),
                    title: Text(strings.bookInfoGenres),
                    content: Consumer<GenresProvider>(
                      // Listen to changes in saved genres.
                      builder: (BuildContext context, GenresProvider provider, Widget? child) => SizedBox(
                        width: dialogWidth,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...List.generate(
                              provider.genres.length + 1,
                              (int index) => index < provider.genres.length
                                  ? GestureDetector(
                                      onTap: () {
                                        final Genre genre = provider.genres[index];

                                        // Only add the genre if not already there.
                                        if (!_book.genres.contains(genre)) {
                                          setState(() {
                                            _book.genres.add(genre);
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(strings.genreAlreadyAdded),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: GenrePreviewWidget(genre: provider.genres[index]),
                                    )
                                  : ListTile(
                                      leading: Text(strings.add),
                                      trailing: const Icon(Icons.add),
                                      onTap: () => Navigator.of(context).pushNamed(EditGenreScreen.routeName),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    )),

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
                  SelectorWidget(
                    label: Text(strings.select),
                    title: Text(strings.publishers),
                    content: Consumer<PublishersProvider>(
                      // Listen to changes in saved publishers.
                      builder: (BuildContext context, PublishersProvider provider, Widget? child) => SizedBox(
                        width: dialogWidth,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...List.generate(
                              provider.publishers.length + 1,
                              (int index) => index < provider.publishers.length
                                  ? ListTile(
                                      leading: Text(provider.publishers[index].name),
                                      onTap: () {
                                        final Publisher publisher = provider.publishers[index];

                                        // Set the book location.
                                        setState(() {
                                          _book.publisher = publisher;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  : ListTile(
                                      leading: Text(strings.add),
                                      trailing: const Icon(Icons.add),
                                      onTap: () => Navigator.of(context).pushNamed(EditPublisherScreen.routeName),
                                    ),
                            ),
                          ],
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
                  SelectorWidget(
                    label: Text(strings.select),
                    title: Text(strings.locations),
                    content: Consumer<StoreLocationsProvider>(
                      // Listen to changes in saved locations.
                      builder: (BuildContext context, StoreLocationsProvider provider, Widget? child) => SizedBox(
                        width: dialogWidth,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...List.generate(
                              provider.locations.length + 1,
                              (int index) => index < provider.locations.length
                                  ? ListTile(
                                      leading: Text(provider.locations[index].name),
                                      onTap: () {
                                        final StoreLocation location = provider.locations[index];

                                        // Set the book location.
                                        setState(() {
                                          _book.location = location;
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  : ListTile(
                                      leading: Text(strings.add),
                                      trailing: const Icon(Icons.add),
                                      onTap: () => Navigator.of(context).pushNamed(EditLocationScreen.routeName),
                                    ),
                            ),
                          ],
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

  Widget _buildAuthorPreview(Author author) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AuthorPreviewWidget(author: author),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _book.authors.remove(author);
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildGenrePreview(Genre genre) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GenrePreviewWidget(genre: genre),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _book.genres.remove(genre);
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildPublisherPreview(Publisher publisher) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: PublisherPreviewWidget(publisher: publisher),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _book.publisher = null;
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationPreview(StoreLocation location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: LocationPreviewWidget(location: location),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              _book.location = null;
            });
          },
          icon: const Icon(
            Icons.cancel_rounded,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
