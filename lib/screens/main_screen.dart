import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/insert_book_screen.dart';
import 'package:shelfish/widgets/book_preview_widget.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/main";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Box<Book> _books = Hive.box<Book>("books");

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
        children: [
          ...List.generate(
            _books.length,
            (index) {
              final Book book = _books.getAt(index)!;
              return BookPreviewWidget(
                book: _books.getAt(index)!,
                onTap: () => setState(() {
                  _books.deleteAt(index);
                }),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final Box box = Hive.box<Book>("books");
          box.add(Book(
              title: "test",
              authors: [Author("Maurizio", "Micheletti")],
              publishDate: 1978,
              genre: Genre(name: "Thriller", color: Colors.red.value),
              publisher: "Mondadori",
              location: "Here"));
          Navigator.of(context).pushNamed(InsertBookScreen.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /*void readFile() async {
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
      final int publishDate = int.parse(columns[4]);

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
  }*/
}
