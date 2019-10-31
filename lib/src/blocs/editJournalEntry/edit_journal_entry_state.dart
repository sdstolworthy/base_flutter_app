import 'package:grateful/src/models/JournalEntry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditJournalEntryState {}

class InitialEdititemState extends EditJournalEntryState {}

class ItemLoaded extends EditJournalEntryState {
  final JournalEntry item;
  ItemLoaded(this.item);
}

class JournalEntrySaved extends EditJournalEntryState {
  final JournalEntry item;
  JournalEntrySaved(this.item);
}

class JournalEntryLoading extends EditJournalEntryState {}

class JournalEntrySaveError extends EditJournalEntryState {}
