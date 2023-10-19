import 'dart:math';

import 'package:flutter/material.dart';

/// Simple elevated button which opens up a dialog.
class DialogButtonWidget extends StatelessWidget {
  final Widget label;
  final Widget title;
  final Widget content;
  final Alignment alignment;

  const DialogButtonWidget({
    Key? key,
    required this.label,
    required this.title,
    required this.content,
    this.alignment = Alignment.center,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: min(mediaQuery.size.width, 300.0),
        child: ElevatedButton(
          child: label,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: title,
                  content: SizedBox(
                    width: 300.0,
                    child: content,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
