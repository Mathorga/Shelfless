import 'package:flutter/material.dart';

import 'package:hive/hive.dart';

part 'genre.g.dart';

@HiveType(typeId: 3)
class Genre {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final Color color;

  Genre({
    required this.name,
    required this.color,
  });
}

enum GenreEnum {
  biology,
  botanics,
  neuroscience,
  chemistry,
  cooking,
  philosophy,
  history,
  arts,
  fiction,
  astronomy,
  geography,
  law,
  economy,
  dictionary,
  ecology,
  encyclopedia,
  epic,
  tales,
  physics,
  comic,
  geology,
  driving,
  computerScience,
  literature,
  languages,
  manual,
  mathematics,
  mineralogy,
  music,
  nature,
  politics,
  psycology,
  religion,
  school,
  sociology,
  sport,
  technics,
  topography,
  zoology,
}

final Map<GenreEnum, Color> genreColors = {
  GenreEnum.biology: const Color.fromARGB(255, 21, 160, 200),
  GenreEnum.botanics: const Color.fromARGB(255, 100, 200, 100),
  GenreEnum.neuroscience: const Color.fromARGB(255, 180, 200, 60),
  GenreEnum.chemistry: const Color.fromARGB(255, 180, 60, 160),
  GenreEnum.cooking: const Color.fromARGB(255, 180, 60, 20),
  GenreEnum.philosophy: const Color.fromARGB(255, 180, 180, 200),
  GenreEnum.history: const Color.fromARGB(255, 120, 80, 0),
  GenreEnum.arts: const Color.fromARGB(255, 200, 170, 20),
  GenreEnum.fiction: const Color.fromARGB(255, 100, 100, 180),
  GenreEnum.astronomy: const Color.fromARGB(255, 50, 0, 200),
  GenreEnum.geography: const Color.fromARGB(255, 80, 240, 160),
  GenreEnum.law: const Color.fromARGB(255, 100, 100, 100),
  GenreEnum.economy: const Color.fromARGB(255, 240, 120, 120),
  GenreEnum.dictionary: const Color.fromARGB(255, 30, 80, 30),
  GenreEnum.ecology: const Color.fromARGB(255, 140, 180, 60),
  GenreEnum.encyclopedia: const Color.fromARGB(255, 80, 30, 80),
  GenreEnum.epic: const Color.fromARGB(255, 240, 100, 60),
  GenreEnum.tales: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.physics: const Color.fromARGB(255, 40, 100, 180),
  GenreEnum.comic: const Color.fromARGB(255, 100, 20, 50),
  GenreEnum.geology: const Color.fromARGB(255, 120, 50, 0),
  GenreEnum.driving: const Color.fromARGB(255, 100, 100, 100),
  GenreEnum.computerScience: const Color.fromARGB(255, 240, 240, 240),
  GenreEnum.literature: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.languages: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.manual: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.mathematics: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.mineralogy: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.music: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.nature: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.politics: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.psycology: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.religion: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.school: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.sociology: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.sport: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.technics: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.topography: const Color.fromARGB(255, 240, 100, 180),
  GenreEnum.zoology: const Color.fromARGB(255, 240, 100, 180),
};
