import 'package:grateful/src/models/journal_entry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditJournalEntryEvent {}

class SaveJournalEntry extends EditJournalEntryEvent {
  final JournalEntry journalEntry;
  SaveJournalEntry(this.journalEntry);
}

class DeleteJournalEntry extends EditJournalEntryEvent {
  final JournalEntry journalEntry;
  DeleteJournalEntry(this.journalEntry);
}
