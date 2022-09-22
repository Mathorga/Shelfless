import 'package:flutter/material.dart';

import 'package:shelfish/models/publisher.dart';

class PublisherPreviewWidget extends StatelessWidget {
  final Publisher publisher;

  const PublisherPreviewWidget({
    Key? key,
    required this.publisher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                publisher.name,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
