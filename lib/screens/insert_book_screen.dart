import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/insert_author_screen.dart';

class InsertBookScreen extends StatefulWidget {
  static const String routeName = "/insert-book";

  const InsertBookScreen({Key? key}) : super(key: key);

  @override
  State<InsertBookScreen> createState() => _InsertBookScreenState();
}

class _InsertBookScreenState extends State<InsertBookScreen> {
  final Box<Book> _books = Hive.box<Book>("books");
  final Box<Author> _authors = Hive.box<Author>("authors");
  final Box<Genre> _genres = Hive.box<Genre>("genres");

  Book book = Book();

  @override
  void initState() {
    super.initState();

    book.authors = HiveList(_authors);
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
              const Text("Title"),
              TextField(
                onChanged: (String value) => book.title = value,
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Authors"),
              if (book.authors!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: book.authors!.map((Author author) => buildAuthorPreview(author)).toList(),
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
                                          onTap: () => Navigator.of(context).pushNamed(InsertAuthorScreen.routeName),
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
              const Text("Publish date"),
              GestureDetector(
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime(currentYear),
                    firstDate: DateTime(0),
                    lastDate: DateTime(currentYear),
                    initialDatePickerMode: DatePickerMode.year,
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(currentYear.toString()),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Genre"),
              // DropdownButton<Genre>(items: [Genre(name: name, color: color)], onChanged: (item) {}),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
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

  Widget buildAuthorPreview(Author author) {
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
