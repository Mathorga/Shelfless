import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';
import 'package:shelfless/utils/strings/strings.dart';

/// Convenience widget for displaying simple error dialogs.
class ErrorDialog extends StatelessWidget {
  final String? message;

  const ErrorDialog({
    super.key,
    this.message,
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
      title: Text(strings.genericErrorTitle),
      content: Text(message ?? strings.genericErrorContent),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        SizedBox(
          width: Themes.buttonWidthMax,
          child: ElevatedButton(
            onPressed: Navigator.of(context).pop,
            child: Text(strings.ok.toUpperCase()),
          ),
        ),
      ],
    );
  }
}

/// Displays an error dialog for a generic unexpected error.
Future<void> showUnexpectedErrorDialog(BuildContext context) {
  return ErrorDialog(message: strings.unexpectedErrorContent).show(context);
}