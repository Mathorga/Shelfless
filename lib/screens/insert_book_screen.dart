import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';

class InsertBookScreen extends StatefulWidget {
  static const String routeName = "/insert-book";

  const InsertBookScreen({Key? key}) : super(key: key);

  @override
  State<InsertBookScreen> createState() => _InsertBookScreenState();
}

class _InsertBookScreenState extends State<InsertBookScreen> {
  final Box<Book> books = Hive.box<Book>("books");
  final Box<Author> authors = Hive.box<Author>("authors");
  final Box<Genre> genres = Hive.box<Genre>("genres");

  Book book = Book();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    book.authors = HiveList(authors);
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
              const TextField(),
              const SizedBox(
                height: 24.0,
                child: Divider(height: 2.0),
              ),
              const Text("Authors"),
              if (book.authors!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: book.authors!.map((Author author) => buildAuthorPreview(author)).toList(),
                  ),
                ),

              if (book.authors!.isEmpty)
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
                                    authors.length + 1,
                                    (int index) => index < authors.length
                                        ? ListTile(leading: Text("${authors.getAt(index)!.firstName} ${authors.getAt(index)!.lastName}"))
                                        : ListTile(
                                            leading: const Text("Add"),
                                            trailing: const Icon(Icons.add),
                                            onTap: () {
                                              // TODO Open insert author dialog.
                                            },
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
          onPressed: () {},
          label: Row(
            children: const [
              Text("Done"),
              SizedBox(width: 12.0),
              Icon(Icons.check),
            ],
          )),
    );
  }

  Widget buildAuthorPreview(Author author) {
    return Card(margin: const EdgeInsets.all(12.0), child: Text(author.firstName));
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
