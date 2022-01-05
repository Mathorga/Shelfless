import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';
import 'package:shelfish/models/genre.dart';

final books = [
  Book(
    "Guida dei Funghi D'Italia e d'Europa",
    [
      Author("Massimo", "Pandolfi"),
      Author("Davide", "Ubaldi"),
    ],
    DateTime(1997),
    Genre.botanics,
    "",
    ""
  ),
  Book(
    "Critica della Ragion Pura",
    [
      Author("Immanuel", "Kant"),
    ],
    DateTime(1972),
    Genre.philosophy,
    "",
    ""
  ),
  Book(
    "Oniria",
    [Author("Maurizio", "Micheletti")],
    DateTime(2013),
    Genre.fiction,
    "",
    ""
  ),
  Book(
    "L'Ascesa e il Declino del Fascismo",
    [Author("Arnaldo", "Pomodoro")],
    DateTime(2000),
    Genre.history,
    "",
    ""
  ),
  Book(
    "I Figli del Tempo",
    [Author("Adrian", "Tchaikovsky")],
    DateTime(2015),
    Genre.fiction,
    "",
    ""
  ),
  Book(
    "Fiori per Algernon",
    [
      Author("Ciro", "Malcony"),
      Author("Mina", "Cerioli"),
      Author("Juan Carlos", "De Espana"),
    ],
    DateTime(1999),
    Genre.fiction,
    "",
    ""
  ),
  Book(
    "Io Robot",
    [Author("Isaac", "Asimov")],
    DateTime(2000),
    Genre.fiction,
    "",
    ""
  ),
  Book(
    "A Thousand Brains",
    [Author("Giovanni", "Palm")],
    DateTime(2019),
    Genre.neuroscience,
    "",
    ""
  ),
];
