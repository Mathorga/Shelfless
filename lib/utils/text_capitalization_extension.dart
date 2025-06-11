import 'package:flutter/material.dart';

extension TextCapitalizationExtension on TextCapitalization {
  String get label => switch(this) {
    TextCapitalization.sentences => "Sentences",
    TextCapitalization.words => "Words",
    TextCapitalization.characters => "Characters",
    TextCapitalization.none => "None",
  };
}