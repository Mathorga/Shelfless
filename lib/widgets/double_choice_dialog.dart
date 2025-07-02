import 'package:flutter/material.dart';

import 'package:shelfless/widgets/double_choice_widget.dart';

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
      content: DoubleChoiceWidget(
        firstOption: firstOption,
        secondOption: secondOption,
        onFirstOptionSelected: onFirstOptionSelected,
        onSecondOptionSelected: onSecondOptionSelected,
      ),
    );
  }
}
