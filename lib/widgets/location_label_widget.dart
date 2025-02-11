import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';
import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class LocationLabelWidget extends StatelessWidget {
  final StoreLocation location;

  const LocationLabelWidget({
    super.key,
    required this.location,
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
                "$location",
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
