import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';

/// Wrapper for displaying unavailable content: darkens its child and captures any interaction with it.
class UnavailableContentWidget extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const UnavailableContentWidget({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: Themes.unavailableFeatureOpacity,
        // Using an absorb pointer widget ensures no tap event is registered by the child.
        child: AbsorbPointer(
          child: child,
        ),
      ),
    );
  }
}
