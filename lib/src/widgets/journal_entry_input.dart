import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/services/localizations/localizations.dart';

typedef void OnChanged(String text);

class JournalInput extends StatelessWidget {
  final OnChanged onChanged;
  final TextEditingController controller;

  JournalInput({@required this.onChanged, @required this.controller});

  build(context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        controller: controller,
        onChanged: this.onChanged,
        minLines: 3,
        cursorColor: Colors.blue[100],
        autocorrect: true,
        autovalidate: true,
        validator: (_) => null,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        style: Theme.of(context).primaryTextTheme.body1.copyWith(fontSize: 18),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).journalEntryHint,
          hintStyle: Theme.of(context)
              .primaryTextTheme
              .body1
              .copyWith(color: Colors.white38, fontStyle: FontStyle.italic),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
        ),
      ),
    ));
  }
}
