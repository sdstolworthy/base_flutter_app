import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class EditJournalEntryBloc extends Bloc<EditJournalEntryEvent, EditJournalEntryState> {
  final JournalEntryRepository _journalEntryRepository;

  EditJournalEntryBloc({JournalEntryRepository journalEntryRepository})
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
    } else if (event is DeleteJournalEntry) {
      try {
        await _journalEntryRepository.deleteItem(event.journalEntry);
        yield JournalEntryDeleted();
      } catch (e) {
        yield JournalEntrySaveError();
      }
    }
  }
}
