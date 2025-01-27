import 'package:flutter/material.dart';

class Themes {
  /// Default spacings, used for edge insets and spacers.
  static const double spacingXSmall = 4.0;
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 12.0;
  static const double spacingLarge = 16.0;
  static const double spacingXLarge = 24.0;
  static const double spacingXXLarge = 32.0;
  static const double spacingXXXLarge = 48.0;
  static const double spacingFAB = 56.0;

  /// Default radiuses, used for borders.
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;

  // Default icon sizes.
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  /// Default max width, used for displaying columns and vertical lists on large screens.
  static const double maxContentWidth = 500.0;

  /// Default max dialog height, used for limiting a dialog's height on tall screens.
  static const double maxDialogHeight = 400.0;

  static const double thumbnailSizeMedium = 200.0;

  static const double actionSize = spacingFAB + spacingLarge;

  /// Default scroll physics, used to animated scrollables (columns, rows, lists, etc).
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();

  /// Simple spacer widget, uses the default app spacing.
  static const Widget spacer = SizedBox(
    width: spacingMedium,
    height: spacingMedium,
  );
}
