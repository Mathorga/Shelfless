import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:shelfless/themes/shelfless_colors.dart';

class Themes {
  static const String appName = "Shelfless";

  /// Default spacings, used for edge insets and spacers.
  static const double spacingXXSmall = 2.0;
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
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;

  // Default icon sizes.
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Default opacity for displaying unavailable features.
  static const double unavailableFeatureOpacity = 0.3;
  static const double foregroundHighlightOpacity = 0.4;
  static const double blurOpacity = 0.1;

  static const double blurStrengthHigh = 20.0;
  static const double blurStrengthMedium = 20.0;

  // Default durations.
  static const Duration durationXShort = Duration(milliseconds: 500);
  static const Duration durationShort = Duration(seconds: 1);
  static const Duration durationMedium = Duration(seconds: 2);
  static const Duration durationLong = Duration(seconds: 5);

  // Default max width, used for displaying columns and vertical lists on large screens.
  static const double maxContentWidth = 500.0;

  // Default max dialog height, used for limiting a dialog's height on tall screens.
  static const double maxDialogHeight = 400.0;

  // Thumbnail sizes.
  static const double thumbnailSizeXSmall = 50.0;
  static const double thumbnailSizeSmall = 100.0;
  static const double thumbnailSizeMedium = 200.0;

  // Snackbar sizes.
  static const double snackBarSizeSmall = 200.0;
  static const double snackBarSizeMedium = 300.0;
  static const double snackBarSizeLarge = 500.0;

  // Font sizes.
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 24.0;

  static const double actionSize = spacingFAB + spacingLarge;

  /// Default scroll physics, used to animated scrollables (columns, rows, lists, etc).
  static const ScrollPhysics scrollPhysics = BouncingScrollPhysics();

  /// Simple spacer widget, uses the default app spacing.
  static const Widget spacer = SizedBox(
    width: spacingMedium,
    height: spacingMedium,
  );

  static final ThemeData _baseTheme = ThemeData(
    scaffoldBackgroundColor: ShelflessColors.mainBackground,
    colorScheme: ColorScheme.dark(
      primary: ShelflessColors.primary,
      secondary: ShelflessColors.secondary,
      surface: ShelflessColors.mainBackground,
    ),
    appBarTheme: const AppBarTheme(
      color: ShelflessColors.mainBackground,
      elevation: 0.0,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
    ),
    dividerTheme: DividerThemeData(
      color: ShelflessColors.onMainBackgroundInactive,
      indent: Themes.spacingLarge,
      endIndent: Themes.spacingLarge,
      thickness: Themes.spacingXXSmall,
    ),
    searchBarTheme: SearchBarThemeData(
      backgroundColor: WidgetStatePropertyAll(ShelflessColors.lightBackground),
    ),
    cardTheme: CardTheme(
      color: ShelflessColors.lightBackground,
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: ShelflessColors.lightBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Themes.radiusMedium),
      ),
      elevation: 6.0,
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: ShelflessColors.mainContentInactive,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Themes.radiusSmall),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: ShelflessColors.mainContentInactive,
      contentTextStyle: TextStyle(color: ShelflessColors.onMainContentActive),
      closeIconColor: ShelflessColors.onMainContentActive,
      actionBackgroundColor: ShelflessColors.onMainContentInactive,
      dismissDirection: DismissDirection.horizontal,
      width: Themes.snackBarSizeSmall,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Themes.radiusSmall),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Themes.radiusMedium),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(Themes.radiusMedium),
      ),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Themes.radiusMedium),
      ),
      backgroundColor: ShelflessColors.lightBackground,
    ),
  );

  static ThemeData shelflessTheme = _baseTheme.copyWith(
    textTheme: GoogleFonts.lexendExaTextTheme(_baseTheme.textTheme),
  );
}
