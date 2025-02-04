import 'package:flutter/material.dart';

import 'package:shelfless/utils/strings/strings.dart';

class UnreleasedFeatureDialog extends StatelessWidget {
  const UnreleasedFeatureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(strings.genericInfo),
      content: Text(strings.unreleasedFeatureAlert),
    );
  }
}