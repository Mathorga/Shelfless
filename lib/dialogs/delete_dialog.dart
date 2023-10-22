import 'package:flutter/material.dart';
import 'package:shelfish/themes/shelfless_colors.dart';

import 'package:shelfish/utils/strings/strings.dart';

class DeleteDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final void Function()? onCancel;
  final void Function()? onConfirm;

  const DeleteDialog({
    Key? key,
    this.title,
    this.content,
    this.onCancel,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop();
          },
          child: Text(strings.no),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: ShelflessColors.error),
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop();
          },
          child: Text(strings.yes),
        ),
      ],
    );
    ;
  }
}
