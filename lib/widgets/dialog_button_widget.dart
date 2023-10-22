import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';

/// Simple elevated button which opens up a dialog.
class DialogButtonWidget extends StatelessWidget {
  final Widget label;
  final Widget title;
  final Widget content;

  const DialogButtonWidget({
    Key? key,
    required this.label,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: label,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(Themes.spacing),
              title: title,
              content: content,
            );
          },
        );
      },
    );
  }
}
