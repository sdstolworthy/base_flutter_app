import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnChanged(String text);

class JournalInput extends StatelessWidget {
  OnChanged onChanged;
  final TextEditingController controller;

  JournalInput(
      {@required this.onChanged, @required this.controller});

  build(context) {
    return TextFormField(
      controller: controller,
      onChanged: this.onChanged,
      autocorrect: true,
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
