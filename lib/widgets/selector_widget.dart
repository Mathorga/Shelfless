import 'package:flutter/material.dart';

class SelectorWidget extends StatelessWidget {
  final Widget label;
  final Widget title;
  final Widget content;

  const SelectorWidget({
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
