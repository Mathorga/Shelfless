import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  final String title;
  const LoadingDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(title),
        content: LinearProgressIndicator(),
      ),
    );
  }
}
