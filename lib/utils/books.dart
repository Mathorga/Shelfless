import 'package:shelfish/models/author.dart';
import 'package:shelfish/models/book.dart';

final books = [
  Book(
    "Moby Dick",
    [
      Author("Giovanni", "Muchacha"),
      Author("Arrigo", "De la Vez"),
    ],
    DateTime(1972),
    "Fantasy",
  ),
  Book(
    "Oniria",
    [Author("Maurizio", "Micheletti")],
    DateTime(2013),
    "Sci-fi",
  ),
  Book(
    "I Figli del Tempo",
    [Author("Adrian", "Tchaikovsky")],
    DateTime(2015),
    "Sci-fi",
  ),
  Book(
    "Fiori per Algernon",
    [
      Author("Ciro", "Malcony"),
      Author("Mina", "Cerioli"),
      Author("Juan Carlos", "De Espana"),
    ],
    DateTime(1999),
    "Sci-fi",
  ),
  Book(
    "Io Robot",
    [Author("Isaac", "Asimov")],
    DateTime(2000),
    "Sci-fi",
  ),
];
