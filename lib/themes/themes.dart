import 'package:flutter/material.dart';

class Themes {
  /// Default spacing, used for edge insets and spacers.
  static const double spacing = 12.0;

  /// Default radius, used for borders.
  static const double radius = 12.0;

  /// Default max width, used for displaying columns and vertical lists on large screens.
  static const double maxContentWidth = 500.0;

  /// Default scroll physics, used to animated scrollables (columns, rows, lists, etc).
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();

  /// Simple spacer widget, uses the default app spacing.
  static const Widget spacer = SizedBox(
    width: spacing,
    height: spacing,
  );
}
