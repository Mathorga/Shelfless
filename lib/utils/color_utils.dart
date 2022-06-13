import 'package:flutter/material.dart';

/// Converts the given color code to a dimmed version used for display purposes.
Color genreColor(int colorCode) => HSLColor.fromColor(Color(colorCode)).withLightness(0.4).toColor();