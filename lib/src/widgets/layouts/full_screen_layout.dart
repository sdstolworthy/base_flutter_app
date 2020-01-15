import 'package:flutter/material.dart';

class FullScreenLayout extends StatelessWidget {
  final Color backgroundColor;
  final Widget child;
  FullScreenLayout({this.backgroundColor, this.child});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Container(
              color: backgroundColor ?? theme.backgroundColor,
              child: SafeArea(child: child),
            ),
          ),
        ],
      ),
    );
  }
}
