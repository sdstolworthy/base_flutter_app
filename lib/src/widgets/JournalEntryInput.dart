import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnChanged(String text);

class JournalInput extends StatelessWidget {
  OnChanged onChanged;
  final String initialValue;

  JournalInput({this.onChanged, this.initialValue});

  build(context) {
    return TextFormField(
      onChanged: this.onChanged,
      autocorrect: true,
      initialValue: initialValue,
      autovalidate: true,
      validator: (_) => null,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
        color: Colors.white,
      ))),
      style: TextStyle(color: Colors.white),
    );
  }
}
