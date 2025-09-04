import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shelfless/utils/strings/strings.dart';

/// Utility class: holds all app settings and controls for customization.
class Config {
  /// If true, shows some useful debugging widgets on top of the default UI.
  /// Devmode is not available in release builds.
  static const bool devmode = true && !kReleaseMode;

  /// Tells whether older version libraries (of books) can be imported or not.
  static const bool allowOutdatedLibraries = true;

  /// Starting value for titles capitalization.
  static const TextCapitalization defaultTitlesCapitalization = TextCapitalization.words;

  /// Starting value for default book cover image.
  static const int defaultBookCoverImage = 2;

  /// Default value for displaying dates.
  static const String defaultDateFormat = "yyyy/MM/dd";

  /// Book date threshold in years in the past: a book can be acquired or read up to 200 years before now.
  static const int pastBookDateThreshold = 200;

  /// Book date threshold in years in the future: a book can be acquired or read up to 10 years from now.
  static const int futureBookDateThreshold = 10;

  /// Starting value for default app locale (language).
  static int defaultAppLocale = AppLocale.system.index;

  /// Email address for support emails.
  static const String supportEmailAddress = "mailto:michelettiluka@gmail.com?subject=Shelfless%20Support";

  // ###############################################################################################################################################################################
  // Features.
  // ###############################################################################################################################################################################

  static const bool eventsFilterByCreatorEnabled = false;

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################
}