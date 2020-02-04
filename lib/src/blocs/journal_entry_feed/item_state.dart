import 'package:grateful/src/models/journal_entry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class JournalFeedState {}

class JournalFeedUnloaded extends JournalFeedState {}

class JournalFeedFetched extends JournalFeedState {
  final List<JournalEntry> journalEntries;
  JournalFeedFetched(this.journalEntries);
}

class JournalFeedFetchError extends JournalFeedState {}
