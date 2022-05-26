import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';
import 'package:shelfish/models/author.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';
import 'package:shelfish/screens/book_info_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/widgets/book_preview_widget.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "/main";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Box<Book> _books = Hive.box<Book>("books");
  final Box<Genre> _genres = Hive.box<Genre>("genres");
  final Box<Author> _authors = Hive.box<Author>("authors");

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search_rounded),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort_rounded),
              onSelected: (String item) {},
              tooltip: "Sort by",
              itemBuilder: (BuildContext context) {
                return {
                  "Title",
                  "Author",
                  "Genre",
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
            PopupMenuButton<String>(
              onSelected: (String item) {},
              itemBuilder: (BuildContext context) {
                return {
                  "Logout",
                  "Settings",
                }.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.book_rounded)),
              Tab(icon: Icon(Icons.topic_rounded)),
              Tab(icon: Icon(Icons.person_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Books list.
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  _books.length,
                  (int index) => BookPreviewWidget(
                    book: _books.getAt(index)!,
                    onTap: () => Navigator.of(context).pushNamed(BookInfoScreen.routeName, arguments: _books.getAt(index)).then((Object? value) => setState(() {})),
                  ),
                )
              ],
            ),

            // Genres list.
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  _genres.length,
                  (int index) => Text(_genres.getAt(index)!.name),
                )
              ],
            ),

            // Authors list.
            ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(8.0),
              children: [
                ...List.generate(
                  _authors.length,
                  (int index) {
                    Author? author = _authors.getAt(index);
                    return Text("${author?.firstName} ${author?.lastName}");
                  }
                )
              ],
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 12.0,
          childrenButtonSize: const Size(64.0, 64.0),
          children: [
            SpeedDialChild(
              label: "Author",
              child: const Icon(Icons.person_rounded),
              onTap: () {
                Navigator.of(context).pushNamed(EditAuthorScreen.routeName);
              },
            ),
            SpeedDialChild(
              label: "Genre",
              child: const Icon(Icons.topic_rounded),
              onTap: () {
                Navigator.of(context).pushNamed(EditGenreScreen.routeName);
              },
            ),
            SpeedDialChild(
              label: "Book",
              child: const Icon(Icons.book_rounded),
              onTap: () {
                Navigator.of(context).pushNamed(EditBookScreen.routeName).then((Object? value) => setState(() {}));
              },
            ),
          ],
        ),
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
