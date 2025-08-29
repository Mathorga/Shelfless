import 'package:flutter/material.dart';

import 'package:shelfless/utils/strings/strings.dart';

class ConfirmDialog extends StatelessWidget {
  final String? title;
  final String? message;

  final void Function()? onNo;
  final void Function()? onYes;

  const ConfirmDialog({
    super.key,
    this.title,
    this.message,
    this.onNo,
    this.onYes,
  });

  /// Displays an error dialog.
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title ?? strings.genericConfirmTitle),
      content: Text(message ?? strings.genericConfirmContent),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: onNo,
          child: Text(strings.no.toUpperCase()),
        ),
        ElevatedButton(
          onPressed: onYes,
          child: Text(strings.yes.toUpperCase()),
        ),
      ],
    );
  }
}