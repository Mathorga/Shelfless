import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';

class EditBookScreen extends StatefulWidget {
  static const String routeName = "/edit-book";

  const EditBookScreen({Key? key}) : super(key: key);

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final Box<Book> _books = Hive.box<Book>("books");
  final Box<Author> _authors = Hive.box<Author>("authors");
  final Box<Genre> _genres = Hive.box<Genre>("genres");

  Book book = Book();

  @override
  void initState() {
    super.initState();

    book.authors = HiveList(_authors);
    book.genres = HiveList(_genres);
  }

  @override
  Widget build(BuildContext context) {
    final int currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Insert Book"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text("Title"),
              TextField(
                onChanged: (String value) => book.title = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Authors.
              const Text("Authors"),
              if (book.authors!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.authors!.map((Author author) => _buildAuthorPreview(author)).toList(),
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
                            content: ListView(
                              shrinkWrap: true,
                              children: [
                                ...List.generate(
                                  _authors.length + 1,
                                  (int index) => index < _authors.length
                                      ? ListTile(
                                          leading: Text("${_authors.getAt(index)!.firstName} ${_authors.getAt(index)!.lastName}"),
                                          onTap: () {
                                            final Author author = _authors.getAt(index)!;

                                            // Only add the author if not already there.
                                            if (!book.authors!.contains(author)) {
                                              setState(() {
                                                book.authors?.add(author);
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

              // Publish date.
              const Text("Publish date"),
              GestureDetector(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text("Select publish year"),
                      content: SizedBox(
                        height: 300.0,
                        child: YearPicker(
                          firstDate: DateTime(0),
                          lastDate: DateTime(currentYear),
                          selectedDate: DateTime(currentYear),
                          onChanged: (DateTime value) {
                            Navigator.of(context).pop();
                            setState(() {
                              book.publishDate = value.year;
                            });
                          },
                        ),
                      ),
                    ),
                  );
                  // DateTime? publishDate = await showDatePicker(
                  //   context: context,
                  //   initialDate: DateTime(currentYear),
                  //   firstDate: DateTime(0),
                  //   lastDate: DateTime(currentYear),
                  //   initialDatePickerMode: DatePickerMode.year,
                  // );

                  // if (publishDate != null) {
                  //   setState(() {
                  //     book.publishDate = publishDate.year;
                  //   });
                  // }
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text((book.publishDate).toString()),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),

              // Genres.
              const Text("Genres"),
              if (book.genres!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.genres!.map((Genre genre) => _buildGenrePreview(genre)).toList(),
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
                            content: ListView(
                              shrinkWrap: true,
                              children: [
                                ...List.generate(
                                  _genres.length + 1,
                                  (int index) => index < _genres.length
                                      ? ListTile(
                                          leading: Text(_genres.getAt(index)!.name),
                                          onTap: () {
                                            final Genre genre = _genres.getAt(index)!;

                                            // Only add the author if not already there.
                                            if (!book.genres!.contains(genre)) {
                                              setState(() {
                                                book.genres?.add(genre);
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
              const TextField(),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (book.title != "" && book.authors!.isNotEmpty) {
            // Actually save a new book.
            _books.add(book);
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
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${author.firstName} ${author.lastName}",
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  book.authors?.remove(author);
                });
              },
              icon: Icon(
                Icons.cancel_rounded,
                color: Colors.red[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenrePreview(Genre genre) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              genre.name,
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  book.genres?.remove(genre);
                });
              },
              icon: Icon(
                Icons.cancel_rounded,
                color: Colors.red[900],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addBook() {
    // final Box booksBox = Hive.box<Book>("books");
    // final Box authorsBox = Hive.box<Book>("authors");
    // final Box genresBox = Hive.box<Book>("genres");

    // booksBox.add(Book(
    //     title: "test",
    //     authors: [Author("Maurizio", "Micheletti")],
    //     publishDate: 1978,
    //     genre: Genre(name: "Thriller", color: Colors.red.value),
    //     publisher: "Mondadori",
    //     location: "Here"));
  }
}
