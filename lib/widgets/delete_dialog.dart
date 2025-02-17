import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/utils/strings/strings.dart';

class DeleteDialog extends StatelessWidget {
  final String? titleString;
  final String? contentString;

  final void Function()? onConfirm;
  final void Function()? onCancel;

  const DeleteDialog({
    super.key,
    this.titleString,
    this.contentString,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: titleString != null ? Text(titleString!) : null,
      content: contentString != null ? Text(contentString!) : null,
      actions: [
        // Cancel button.
        TextButton(
          onPressed: () {
            // Prefetch handlers before async gaps.
            final NavigatorState navigator = Navigator.of(context);

            onCancel?.call();

            // Pop back.
            navigator.pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: ShelflessColors.onMainContentActive,
          ),
          child: Text(strings.cancel),
        ),

        // Confirm button.
        ElevatedButton(
          onPressed: () {
            // Prefetch handlers before async gaps.
            final NavigatorState navigator = Navigator.of(context);

            onConfirm?.call();

            // Pop back.
            navigator.pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ShelflessColors.error,
            iconColor: ShelflessColors.onMainContentActive,
            foregroundColor: ShelflessColors.onMainContentActive,
          ),
          child: Text(strings.ok),
        ),
      ],
    );
  }
}
