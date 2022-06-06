import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

import 'package:shelfish/models/book.dart';
import 'package:shelfish/providers/books_provider.dart';
import 'package:shelfish/widgets/authors_overview_widget.dart';
import 'package:shelfish/screens/book_info_screen.dart';
import 'package:shelfish/screens/edit_author_screen.dart';
import 'package:shelfish/screens/edit_book_screen.dart';
import 'package:shelfish/screens/edit_genre_screen.dart';
import 'package:shelfish/screens/edit_location_screen.dart';
import 'package:shelfish/widgets/genres_overview_widget.dart';
import 'package:shelfish/screens/locations_overview_screen.dart';
import 'package:shelfish/widgets/book_preview_widget.dart';

class BooksOverviewScreenOld extends StatefulWidget {
  static const String routeName = "/books_overview";

  const BooksOverviewScreenOld({Key? key}) : super(key: key);

  @override
  State<BooksOverviewScreenOld> createState() => _BooksOverviewScreenOldState();
}

class _BooksOverviewScreenOldState extends State<BooksOverviewScreenOld> {
  AppBar _buildAppBar(BooksProvider booksProvider) {
    return AppBar(
      title: const Text("Books"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.sort_rounded),
          onSelected: (String item) {
            switch (item) {
              case "Title":
                booksProvider.setSorting((Book book1, Book book2) => book1.title.compareTo(book2.title));
                break;
              case "Publish Date":
                booksProvider.setSorting((Book book1, Book book2) => book1.publishDate.compareTo(book2.publishDate));
                break;
            }
          },
          tooltip: "Sort by",
          itemBuilder: (BuildContext context) {
            return {
              "Title",
              "Publish Date",
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (String item) {
            switch (item) {
              case "Genres":
                // Navigate to the genres overview.
                Navigator.of(context).pushNamed(GenresOverviewWidget.routeName);
                break;
              case "Authors":
                // Navigate to the authors overview.
                Navigator.of(context).pushNamed(AuthorsOverviewWidget.routeName);
                break;
              case "Location":
                // Navigate to the authors overview.
                Navigator.of(context).pushNamed(LocationsOverviewScreen.routeName);
                break;
              default:
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {
              "Genres",
              "Authors",
              "Locations",
            }.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the books provider and listen for changes.
    final BooksProvider booksProvider = Provider.of(context, listen: true);

    return Scaffold(
      appBar: _buildAppBar(booksProvider),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text("Filter"),
            ),
            ListTile(
              title: const Text("Hello"),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        children: [
          ...List.generate(
            booksProvider.books.length,
            (int index) => BookPreviewWidget(
              book: booksProvider.books[index],
              onTap: () => Navigator.of(context).pushNamed(BookInfoScreen.routeName, arguments: booksProvider.books[index]),
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 12.0,
        childrenButtonSize: const Size(64.0, 64.0),
        children: [
          SpeedDialChild(
            label: "Location",
            child: const Icon(Icons.location_on_rounded),
            onTap: () {
              Navigator.of(context).pushNamed(EditLocationScreen.routeName);
            },
          ),
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
              Navigator.of(context).pushNamed(EditBookScreen.routeName);
            },
          ),
        ],
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
