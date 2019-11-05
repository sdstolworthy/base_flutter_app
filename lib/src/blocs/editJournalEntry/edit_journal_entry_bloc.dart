import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/journalEntryFeed/bloc.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class EditJournalEntryBloc
    extends Bloc<EditJournalEntryEvent, EditJournalEntryState> {
  final JournalEntryRepository _journalEntryRepository;
  final JournalFeedBloc _journalFeedBloc;

  EditJournalEntryBloc(
      {JournalEntryRepository journalEntryRepository,
      @required JournalFeedBloc journalFeedBloc})
      : this._journalEntryRepository =
            journalEntryRepository ?? JournalEntryRepository(),
        _journalFeedBloc = journalFeedBloc;

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
        _journalFeedBloc.add(FetchFeed());
        yield JournalEntrySaved(journalEntry);
      } catch (e) {
        print(e);
        yield JournalEntrySaveError();
      }
    } else if (event is DeleteJournalEntry) {
      try {
        await _journalEntryRepository.deleteItem(event.journalEntry);
        _journalFeedBloc.add(FetchFeed());
        yield JournalEntryDeleted();
      } catch (e) {
        yield JournalEntrySaveError();
      }
    }
  }
}
