import 'package:flutter/material.dart';

import 'package:shelfless/themes/shelfless_colors.dart';
import 'package:shelfless/themes/themes.dart';

class AppNameWidget extends StatelessWidget {
  final TextStyle? textStyle;

  const AppNameWidget({
    super.key,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ShaderMask(
      shaderCallback: (Rect rect) => LinearGradient(
        colors: [
          ShelflessColors.secondary,
          ShelflessColors.primary,
        ],
      ).createShader(rect),
      child: Text(
        Themes.appName,
        style: textStyle ?? theme.textTheme.headlineMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
