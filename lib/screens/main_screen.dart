import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Book> _books = [];

  @override
  void initState() {
    super.initState();

    readDb();
    // readFile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        children: _books
            .map((Book book) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0), side: BorderSide(color: Color(book.genre.color), width: 4.0)),
                  shadowColor: Color(book.genre.color),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12.0),
                        book.authors.length <= 2
                            ? Text(book.authors.map((Author author) => author.toString()).reduce((String value, String element) => "$value, $element"))
                            : Text("${book.authors.first}, altri"),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Box box = Hive.box<Book>("books");
          box.add(Book(
              title: "test",
              authors: [Author("Maurizio", "Micheletti")],
              publishDate: DateTime(1978),
              genre: Genre(name: "Thriller", color: Colors.red.value),
              publisher: "Mondadori",
              location: "Here")).then((int i) => print("RESULT $i"));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void readDb() {
    final Box box = Hive.box<Book>("books");

    setState(() {
      _books.addAll(box.toMap().values.toList() as List<Book>);
    });
  }

  void readFile() async {
    final String fileString = await rootBundle.loadString("assets/BIBLIOTECA.csv", cache: false);

    final List<String> lines = const LineSplitter().convert(fileString);
    for (String line in lines.skip(1)) {
      final List<String> columns = line.split("|");

      // Genre.
      GenreEnum genre;
      switch (columns[0]) {
        case "ARTE":
          genre = GenreEnum.arts;
          break;
        case "ASTRONOMIA":
          genre = GenreEnum.astronomy;
          break;
        case "ATLANTI":
          genre = GenreEnum.geography;
          break;
        case "BIOLOGIA":
          genre = GenreEnum.biology;
          break;
        case "BOTANICA":
          genre = GenreEnum.botanics;
          break;
        case "CHIMICA":
          genre = GenreEnum.chemistry;
          break;
        case "CUCINA":
          genre = GenreEnum.cooking;
          break;
        case "DIRITTO":
          genre = GenreEnum.law;
          break;
        case "DIZIONARIO":
          genre = GenreEnum.dictionary;
          break;
        case "ECOLOGIA":
          genre = GenreEnum.ecology;
          break;
        case "ECONOMIA":
          genre = GenreEnum.economy;
          break;
        case "ENCICLOPEDIA":
          genre = GenreEnum.encyclopedia;
          break;
        case "EPICA":
          genre = GenreEnum.epic;
          break;
        case "FAVOLE":
          genre = GenreEnum.tales;
          break;
        case "FILOSOFIA":
          genre = GenreEnum.philosophy;
          break;
        case "FISICA":
          genre = GenreEnum.physics;
          break;
        case "FUMETTO":
          genre = GenreEnum.comic;
          break;
        case "GEOLOGIA":
          genre = GenreEnum.geology;
          break;
        case "GUIDA":
          genre = GenreEnum.driving;
          break;
        case "INFORMATICA":
          genre = GenreEnum.computerScience;
          break;
        case "LETTERATURA":
          genre = GenreEnum.literature;
          break;
        case "LINGUA":
          genre = GenreEnum.languages;
          break;
        case "MANUALE":
          genre = GenreEnum.manual;
          break;
        case "MATEMATICA":
          genre = GenreEnum.mathematics;
          break;
        case "MINERALOGIA":
          genre = GenreEnum.mineralogy;
          break;
        case "MUSICA":
          genre = GenreEnum.music;
          break;
        case "NARRATIVA":
          genre = GenreEnum.fiction;
          break;
        case "NATURA":
          genre = GenreEnum.nature;
          break;
        case "NEUROSCIENZE":
          genre = GenreEnum.neuroscience;
          break;
        case "POLITICA":
          genre = GenreEnum.politics;
          break;
        case "PSICOLOGIA":
          genre = GenreEnum.psycology;
          break;
        case "RELIGIONE":
          genre = GenreEnum.religion;
          break;
        case "SCUOLA":
          genre = GenreEnum.school;
          break;
        case "SOCIOLOGIA":
          genre = GenreEnum.sociology;
          break;
        case "SPORT":
          genre = GenreEnum.sport;
          break;
        case "STORIA":
          genre = GenreEnum.history;
          break;
        case "TECNICA":
          genre = GenreEnum.technics;
          break;
        case "TOPOGRAFIA":
          genre = GenreEnum.topography;
          break;
        case "ZOOLOGIA":
          genre = GenreEnum.zoology;
          break;
        default:
          genre = GenreEnum.arts;
          break;
      }

      // Title.
      final String title = columns[1];

      // Authors.
      List<Author> authors = [];
      final List<String> authorStrings = columns[2].split("-");
      for (String authorString in authorStrings) {
        final List<String> authorParts = authorString.split(" ");
        final String firstName = authorParts.first.split(".").first;
        final String lastName = authorParts.last.split(".").last;
        authors.add(Author(firstName, lastName));
      }

      // Publisher.
      final String publisher = columns[3];

      // Publish date.
      final DateTime publishDate = DateTime(int.parse(columns[4]));

      // Location.
      final String location = columns[5];

      setState(() {
        _books.add(Book(
          // id: Random().nextInt(0xFFFFFFFF),
          title: title,
          authors: authors,
          publishDate: publishDate,
          genre: Genre(name: "Zoologia", color: Colors.amber.value),
          // genreEnum: genre,
          publisher: publisher,
          location: location,
        ));
      });
    }
  }
}
