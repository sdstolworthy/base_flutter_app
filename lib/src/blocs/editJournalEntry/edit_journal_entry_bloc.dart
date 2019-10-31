import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class EditItemBloc extends Bloc<EditJournalEntryEvent, EditJournalEntryState> {
  final JournalEntryRepository _journalEntryRepository;

  EditItemBloc({JournalEntryRepository journalEntryRepository})
      : this._journalEntryRepository =
            journalEntryRepository ?? JournalEntryRepository();

  @override
  EditJournalEntryState get initialState => InitialEdititemState();

  @override
  Stream<EditJournalEntryState> mapEventToState(
    EditJournalEntryEvent event,
  ) async* {
    if (event is SaveJournalEntry) {
      try {
        yield JournalEntryLoading();
        final journalEntry =
            await _journalEntryRepository.saveItem(event.journalEntry);
        yield JournalEntrySaved(journalEntry);
      } catch (e) {
        print(e);
        yield JournalEntrySaveError();
      }
    }
  }
}
