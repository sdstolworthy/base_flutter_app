import 'package:flutter/material.dart';

class Shadower extends StatelessWidget {
  final Widget child;
  Shadower({@required this.child});
  build(c) {
    return Container(
      child: child,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(spreadRadius: 0.5, blurRadius: 1, offset: Offset(0.5, 0.5))
      ]),
    );
  }
}
