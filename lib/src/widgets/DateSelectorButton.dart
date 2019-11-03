import 'package:grateful/src/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateSelectorButton extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(BuildContext context) onPressed;
  final Locale locale;
  DateSelectorButton({this.selectedDate, this.onPressed, Locale locale})
      : this.locale = locale ?? Locale('en_US');
  build(BuildContext context) {
    return FlatButton(
      child: Text(
        Validators.formatDate(selectedDate, locale),
        style: Theme.of(context).primaryTextTheme.body1.copyWith(fontSize: 18),
      ),
      onPressed: () {
        onPressed(context);
      },
      color: Colors.blue[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
