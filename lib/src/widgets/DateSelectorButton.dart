import 'package:grateful/src/helpers/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DateSelectorButton extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(BuildContext context) onPressed;
  DateSelectorButton({this.selectedDate, this.onPressed});

  build(BuildContext context) {
    return FlatButton(
      child: Text(Validators.formatDate(selectedDate),
          style: TextStyle(color: Colors.white)),
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
