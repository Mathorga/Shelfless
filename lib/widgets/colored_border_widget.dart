import 'package:flutter/material.dart';
import 'package:shelfless/themes/themes.dart';

class ColoredBorderWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final double? thickness;
  final double? borderRadius;
  final Widget? child;
  final List<Color> colors;

  const ColoredBorderWidget({
    super.key,
    this.width,
    this.height,
    this.thickness,
    this.borderRadius,
    this.child,
    this.colors = const [],
  });

  @override
  Widget build(BuildContext context) {
    // Prepare border radius.
    double outerRadius = borderRadius ?? Themes.radiusMedium;
    double coverPadding = thickness ?? Themes.spacingSmall;
    double innerRadius = outerRadius - coverPadding;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: colors.isNotEmpty
              ? colors.length >= 2
                  ? colors
                  : [
                      colors.first,
                      colors.first,
                    ]
              : [
                  Colors.transparent,
                  Colors.transparent,
                ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(coverPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(innerRadius),
          child: child,
        ),
      ),
      // child: child,
    );
  }
}
