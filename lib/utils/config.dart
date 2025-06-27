import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Utility class: holds all app settings and controls for customization.
class Config {
  /// If true, shows some useful debugging widgets on top of the default UI.
  /// Devmode is not available in release builds.
  static const bool devmode = true && !kReleaseMode;

  /// Starting value for titles capitalization.
  static const TextCapitalization defaultTitlesCapitalization = TextCapitalization.words;

  /// Starting value for default book cover image.
  static const int defaultBookCoverImage = 2;

  /// Email address for support emails.
  static const String supportEmailAddress = "mailto:michelettiluka@gmail.com?subject=Shelfless%20Support";

  // ###############################################################################################################################################################################
  // Features.
  // ###############################################################################################################################################################################

  static const bool eventsFilterByCreatorEnabled = false;

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################
}