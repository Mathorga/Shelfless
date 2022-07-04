import 'package:flutter/material.dart';

class SeparatorWidget extends StatelessWidget {
  final Widget? child;

  const SeparatorWidget({
    Key? key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      child: child,
    );
  }
}
