import 'package:flutter/material.dart';

class FullScreenLayout extends StatelessWidget {
  const FullScreenLayout({this.backgroundColor, this.child});

  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
