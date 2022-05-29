import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/models/store_location.dart';
import 'package:shelfish/providers/authors_provider.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/providers/genres_provider.dart';
import 'package:shelfish/providers/store_locations_provider.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/edit_location_screen.dart';
import 'package:shelfish/widgets/author_preview_widget.dart';
import 'package:shelfish/widgets/genre_preview_widget.dart';
import 'package:shelfish/widgets/location_preview_widget.dart';

class EditBookScreen extends StatefulWidget {
  static const String routeName = "/edit-book";

  const EditBookScreen({Key? key}) : super(key: key);

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
    // Fetch provider.
    final BooksProvider booksProvider = Provider.of(context, listen: false);

    // Fetch passed arguments.
    Book? receivedBook = ModalRoute.of(context)!.settings.arguments as Book?;
    _inserting = receivedBook == null;

    const double dialogWidth = 300.0;

    if (!_inserting) {
      _book = receivedBook!;
    }

    final int currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: Text("${_inserting ? "Insert" : "Edit"} Book"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text("Title"),
              TextFormField(
                initialValue: _book.title,
                onChanged: (String value) => _book.title = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Authors.
              const Text("Authors"),
              if (_book.authors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _book.authors.map((Author author) => _buildAuthorPreview(author)).toList(),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    child: const Text("Add one"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Authors"),
                            content: Consumer<AuthorsProvider>(
                              // Listen to changes in saved authors.
                              builder: (BuildContext context, AuthorsProvider provider, Widget? child) => SizedBox(
                                width: dialogWidth,
                                child: ListView(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  children: [
                                    ...List.generate(
                                      provider.authors.length + 1,
                                      (int index) => index < provider.authors.length
                                          ? ListTile(
                                              leading: Text("${provider.authors[index].firstName} ${provider.authors[index].lastName}"),
                                              onTap: () {
                                                final Author author = provider.authors[index];

                                                // Only add the author if not already there.
                                                if (!_book.authors.contains(author)) {
                                                  setState(() {
                                                    _book.authors.add(author);
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Author already added"),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          : ListTile(
                                              leading: const Text("Add"),
                                              trailing: const Icon(Icons.add),
                                              onTap: () => Navigator.of(context).pushNamed(EditAuthorScreen.routeName),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Publish year.
              const Text("Publish date"),
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Select publish year"),
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
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Genres.
              const Text("Genres"),
              if (_book.genres.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _book.genres.map((Genre genre) => _buildGenrePreview(genre)).toList(),
                  ),
                ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    child: const Text("Add one"),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Genres"),
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
                                          ? ListTile(
                                              leading: Text(provider.genres[index].name),
                                              onTap: () {
                                                final Genre genre = provider.genres[index];

                                                // Only add the genre if not already there.
                                                if (!_book.genres.contains(genre)) {
                                                  setState(() {
                                                    _book.genres.add(genre);
                                                  });
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      content: Text("Genre already added"),
                                                      duration: Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          : ListTile(
                                              leading: const Text("Add"),
                                              trailing: const Icon(Icons.add),
                                              onTap: () => Navigator.of(context).pushNamed(EditGenreScreen.routeName),
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Publisher.
              const Text("Publisher"),
              TextFormField(
                initialValue: _book.publisher,
                onChanged: (String value) => _book.publisher = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Location.
              const Text("Location"),
              if (_book.location != null)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: _buildLocationPreview(_book.location!),
                ),

              if (_book.location == null)
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      child: const Text("Select"),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Locations"),
                              content: Consumer<StoreLocationsProvider>(
                                // Listen to changes in saved genres.
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
                                                leading: const Text("Add"),
                                                trailing: const Icon(Icons.add),
                                                onTap: () => Navigator.of(context).pushNamed(EditLocationScreen.routeName),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 88.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_book.title != "" && _book.authors.isNotEmpty && _book.genres.isNotEmpty) {
            // Actually save the book.
            _inserting ? booksProvider.addBook(_book) : booksProvider.updateBook(_book);
            Navigator.of(context).pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No title provided"),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        label: Row(
          children: const [
            Text("Done"),
            SizedBox(width: 12.0),
            Icon(Icons.check),
          ],
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
