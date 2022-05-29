import 'package:flutter/material.dart';

import 'package:shelfish/models/store_location.dart';

class LocationPreviewWidget extends StatelessWidget {
  final StoreLocation location;

  const LocationPreviewWidget({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              location.name,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
