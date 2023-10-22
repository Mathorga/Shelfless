import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shelfish/themes/shelfless_colors.dart';
import 'package:shelfish/themes/themes.dart';

/// Default wrapper for edit sections.
class EditSectionWidget extends StatelessWidget {
  final List<Widget> children;
  const EditSectionWidget({
    Key? key,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return SizedBox(
      width: min(mediaQuery.size.width, Themes.maxContentWidth),
      child: Card(
        color: ShelflessColors.lightBackground,
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }
}
