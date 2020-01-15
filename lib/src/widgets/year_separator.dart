import 'package:flutter/material.dart';

class YearSeparator extends StatelessWidget {
  final String year;
  YearSeparator(this.year);
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            year,
            style: Theme.of(context).primaryTextTheme.subhead,
          )
        ],
      ),
    );
  }
}
