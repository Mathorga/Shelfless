import 'package:flutter/widgets.dart';

import 'package:shelfless/themes/themes.dart';

/// Wrapper for displaying unavailable content.
// TODO Add onTap callback function?
class UnavailableContentWidget extends StatelessWidget {
  final Widget child;

  const UnavailableContentWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: Themes.unavailableFeatureOpacity,
      child: child,
    );
  }
}
