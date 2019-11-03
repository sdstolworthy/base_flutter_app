import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef void OnChanged(String text);

class JournalInput extends StatelessWidget {
  OnChanged onChanged;
  final TextEditingController controller;

  JournalInput({@required this.onChanged, @required this.controller});

  build(context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue[800],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            keyboardType: TextInputType.multiline,
            controller: controller,
            onChanged: this.onChanged,
            autocorrect: true,
            autovalidate: true,
            validator: (_) => null,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            style:
                Theme.of(context).primaryTextTheme.body1.copyWith(fontSize: 18),
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ));
  }
}
