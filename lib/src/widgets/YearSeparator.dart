import 'package:flutter/material.dart';

class YearSeparator extends StatelessWidget {
  @override
  final String year;
  YearSeparator(this.year);
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text(year, style: Theme.of(context).primaryTextTheme.subhead,)],
    );
  }
}
