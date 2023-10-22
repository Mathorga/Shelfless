import 'package:flutter/material.dart';

import 'package:shelfless/models/store_location.dart';

class LocationPreviewWidget extends StatelessWidget {
  final StoreLocation location;

  const LocationPreviewWidget({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                location.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
