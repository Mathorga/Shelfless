import 'package:flutter/material.dart';

class UnfocusWidget extends StatelessWidget {
  final Widget child;

  const UnfocusWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove any focus on tap.
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
