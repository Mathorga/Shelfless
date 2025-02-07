import 'package:flutter/material.dart';

import 'package:shelfless/widgets/unavailable_content_widget.dart';
import 'package:shelfless/widgets/unreleased_feature_dialog.dart';

/// Darkens its content and displays an unreleased info dialog on tap.
class UnreleasedFeatureWidget extends StatelessWidget {
  final Widget child;

  const UnreleasedFeatureWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return UnavailableContentWidget(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => UnreleasedFeatureDialog(),
        );
      },
      child: child,
    );
  }
}