import 'package:flutter/material.dart';

enum Genre {
  biology,
  botanics,
  neuroscience,
  chemistry,
  cooking,
  philosophy,
  history,
  arts,
  fiction,
}

final genreColors = {
  Genre.biology: const Color.fromARGB(255, 21, 160, 200),
  Genre.botanics: const Color.fromARGB(255, 100, 200, 120),
  Genre.neuroscience: const Color.fromARGB(255, 180, 200, 60),
  Genre.chemistry: const Color.fromARGB(255, 180, 60, 160),
  Genre.cooking: const Color.fromARGB(255, 180, 60, 20),
  Genre.philosophy: Colors.grey,
  Genre.history: const Color.fromARGB(255, 120, 80, 0),
  Genre.arts: const Color.fromARGB(255, 200, 170, 20),
  Genre.fiction: const Color.fromARGB(255, 240, 100, 180),
};
