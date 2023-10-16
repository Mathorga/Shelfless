import 'package:flutter/material.dart';

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
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        child: ElevatedButton(
          child: label,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: title,
                  content: SizedBox(
                    width: 300.0,
                    child: content,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
