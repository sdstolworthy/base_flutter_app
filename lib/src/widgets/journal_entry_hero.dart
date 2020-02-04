import 'package:flutter/material.dart';
import 'package:grateful/src/models/journal_entry.dart';

class JournalEntryHero extends StatelessWidget {
  final JournalEntry journalEntry;
  final bool inverted;
  JournalEntryHero({@required this.journalEntry, this.inverted});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: journalEntry.id,
      child: Text(
        journalEntry.body,
        style: this.inverted == null || this.inverted == false
            ? Theme.of(context).primaryTextTheme.body1
            : Theme.of(context).accentTextTheme.body1,
      ),
    );
  }
}
