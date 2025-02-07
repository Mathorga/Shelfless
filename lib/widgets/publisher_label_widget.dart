import 'package:flutter/material.dart';

import 'package:shelfless/models/publisher.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class PublisherLabelWidget extends StatelessWidget {
  final Publisher publisher;

  const PublisherLabelWidget({
    super.key,
    required this.publisher,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ShelflessColors.mainContentActive,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(Themes.spacingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$publisher",
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
