import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Utility class: holds all app settings and controls for customization.
class Config {
  /// If true, shows some useful debugging widgets on top of the default UI.
  /// Devmode is not available in release builds.
  static const bool devmode = true && !kReleaseMode;

  /// Starting value for titles capitalization.
  static const TextCapitalization defaultTitlesCapitalization = TextCapitalization.words;

  // ###############################################################################################################################################################################
  // Features.
  // ###############################################################################################################################################################################

  static const bool eventsFilterByCreatorEnabled = false;

  // ###############################################################################################################################################################################
  // ###############################################################################################################################################################################
}