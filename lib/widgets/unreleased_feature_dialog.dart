import 'package:flutter/material.dart';
import 'package:shelfless/utils/strings/strings.dart';

class UnreleasedFeatureDialog extends StatelessWidget {
  const UnreleasedFeatureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(strings.warning),
      content: Text(strings.unreleasedFeatureAlert),
    );
  }
}