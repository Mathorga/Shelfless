import 'package:flutter/material.dart';

import 'package:shelfless/themes/themes.dart';

class DoubleChoiceDialog extends StatelessWidget {
  final Widget? title;

  final Widget firstOption;
  final Widget secondOption;

  final void Function()? onFirstOptionSelected;
  final void Function()? onSecondOptionSelected;

  const DoubleChoiceDialog({
    super.key,
    this.title,
    required this.firstOption,
    required this.secondOption,
    this.onFirstOptionSelected,
    this.onSecondOptionSelected
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: Row(
        spacing: Themes.spacingMedium,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _buildOption(
              onPressed: onFirstOptionSelected,
              child: firstOption,
            ),
          ),
          Expanded(
            child: _buildOption(
              onPressed: onSecondOptionSelected,
              child: secondOption,
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildOption({
    required Widget child,
    void Function()? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: Themes.thumbnailSizeSmall,
        height: Themes.thumbnailSizeSmall,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
