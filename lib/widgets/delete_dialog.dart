import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final void Function()? onYes;
  final void Function()? onNo;

  const DeleteDialog({
    Key? key,
    required this.title,
    required this.onYes,
    required this.onNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete $title?"),
      content: const Text("Are you sure you want to delete this?"),
      actions: [
        TextButton(
          onPressed: () {
            // Callback.
            onNo?.call();

            // Pop the dialog.
            Navigator.of(context).pop();
          },
          child: const Text("No"),
        ),
        TextButton(
          onPressed: () {
            // Callback.
            onYes?.call();

            // Pop the dialog.
            Navigator.of(context).pop();

            // Pop the info screen.
            Navigator.of(context).pop();
          },
          child: const Text("Yes"),
        ),
      ],
    );
  }
}
