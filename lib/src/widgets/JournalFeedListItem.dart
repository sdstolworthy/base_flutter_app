import 'package:flutter/material.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/widgets/JournalEntryHero.dart';
import 'package:intl/intl.dart';

typedef void OnPressed();

class JournalEntryListItem extends StatelessWidget {
  final JournalEntry journalEntry;
  final OnPressed onPressed;
  JournalEntryListItem({@required this.journalEntry, this.onPressed});
  build(context) {
    final theme = Theme.of(context);
    return FlatButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                DateFormat.d().format(journalEntry.date),
                style: theme.primaryTextTheme.headline,
              ),
              Text(
                DateFormat.MMM().format(journalEntry.date),
                style: theme.primaryTextTheme.body1,
              )
            ],
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: JournalEntryHero(
                journalEntry: journalEntry,
              ),
            ),
          )
        ],
      ),
    );
  }
}
