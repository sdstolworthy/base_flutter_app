import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class JournalInput extends StatelessWidget {
  final TextEditingController inputController;

  JournalInput(this.inputController);
  
  build(context) {
    return TextFormField(
      controller: inputController,
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
