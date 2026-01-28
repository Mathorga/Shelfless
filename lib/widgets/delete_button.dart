import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';

class DeleteButton extends StatelessWidget {
  final void Function()? onPressed;

  const DeleteButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed?.call();
      },
      child: Icon(
        Icons.close_rounded,
        color: ShelflessColors.errorLight,
      ),
    );
  }
}
