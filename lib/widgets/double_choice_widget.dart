import 'package:flutter/material.dart';
import 'package:shelfless/themes/themes.dart';

class DoubleChoiceWidget extends StatelessWidget {
  final Widget firstOption;
  final Widget secondOption;

  final void Function()? onFirstOptionSelected;
  final void Function()? onSecondOptionSelected;

  final double? optionsHeight;

  const DoubleChoiceWidget({
    super.key,
    required this.firstOption,
    required this.secondOption,
    this.onFirstOptionSelected,
    this.onSecondOptionSelected,
    this.optionsHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildOption({
    required Widget child,
    void Function()? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: optionsHeight ?? Themes.thumbnailSizeSmall,
        height: optionsHeight ?? Themes.thumbnailSizeSmall,
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
