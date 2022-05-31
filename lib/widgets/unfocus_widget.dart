import 'package:flutter/material.dart';

class UnfocusWidget extends StatelessWidget {
  final Widget child;

  const UnfocusWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

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
