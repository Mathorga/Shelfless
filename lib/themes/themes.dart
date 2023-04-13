import 'package:flutter/material.dart';

class Themes {
  static const double spacing = 12.0;
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();
  static const Widget spacer = SizedBox(
    width: spacing,
    height: spacing,
  );
}
