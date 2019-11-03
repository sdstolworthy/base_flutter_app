import 'package:flutter/material.dart';
import 'package:grateful/src/models/JournalEntry.dart';

class JournalEntryHero extends StatelessWidget {
  final JournalEntry journalEntry;
  JournalEntryHero({@required this.journalEntry});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: journalEntry.id,
      child: Text(
        journalEntry.body,
        style: Theme.of(context).primaryTextTheme.body1,
      ),
    );
  }
}
