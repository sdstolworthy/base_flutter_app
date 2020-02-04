import 'package:flutter/material.dart';

class NoGlowScroll extends ScrollBehavior {
  final bool showLeading;
  final bool showTrailing;
  final AxisDirection axisDirection;
  final Color color;
  NoGlowScroll(
      {this.showLeading = true,
      this.showTrailing = true,
      this.axisDirection = AxisDirection.down,
      Color color})
      : color = color ?? Colors.white.withOpacity(0.1);
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return GlowingOverscrollIndicator(
      color: color,
      axisDirection: axisDirection,
      showTrailing: showTrailing,
      showLeading: showLeading,
      child: child,
    );
  }
}
