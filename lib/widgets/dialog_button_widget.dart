import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';

/// Simple elevated button which opens up a dialog.
class DialogButtonWidget extends StatelessWidget {
  final Widget label;
  final Widget title;
  final Widget content;

  const DialogButtonWidget({
    super.key,
    required this.label,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return ElevatedButton(
      child: label,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: title,
              content: SizedBox(
                width: min(screenSize.width, Themes.maxContentWidth),
                height: Themes.maxDialogHeight,
                child: content,
              ),
            );
          },
        );
      },
    );
  }
}
