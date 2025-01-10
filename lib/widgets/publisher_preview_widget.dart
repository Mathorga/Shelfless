import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class PublisherPreviewWidget extends StatelessWidget {
  final Publisher publisher;
  final void Function()? onTap;

  const PublisherPreviewWidget({
    Key? key,
    required this.publisher,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: Theme.of(context).cardTheme.elevation,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(Themes.spacingMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  publisher.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ShelflessColors.onMainContentActive),
                ),
                if (publisher.website != null)
                  Text(
                    publisher.website!,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
