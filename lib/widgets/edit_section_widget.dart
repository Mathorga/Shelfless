import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

/// Default wrapper for edit sections.
class EditSectionWidget extends StatelessWidget {
  final double spacing;
  final List<Widget> children;

  const EditSectionWidget({
    super.key,
    this.spacing = 0.0,
    this.children = const [],
  });

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return SizedBox(
      width: min(mediaQuery.size.width, Themes.maxContentWidth),
      child: Card(
        color: ShelflessColors.lightBackground,
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacingMedium),
          child: Column(
            spacing: spacing,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
