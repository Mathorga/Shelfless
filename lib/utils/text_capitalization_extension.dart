import 'package:flutter/material.dart';
import 'package:shelfless/utils/strings/strings.dart';

extension TextCapitalizationExtension on TextCapitalization {
  String get label => switch(this) {
    TextCapitalization.sentences => strings.textCapitalizationSentences(),
    TextCapitalization.words => strings.textCapitalizationWords(),
    TextCapitalization.characters => strings.textCapitalizationCharacters(),
    TextCapitalization.none => strings.textCapitalizationNone(),
  };
}