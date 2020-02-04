import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/journal_entry_feed/bloc.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import 'package:grateful/src/repositories/analytics/AnalyticsRepository.dart';
import './bloc.dart';

class EditJournalEntryBloc
    extends Bloc<EditJournalEntryEvent, EditJournalEntryState> {
  final JournalEntryRepository _journalEntryRepository;
  final JournalFeedBloc _journalFeedBloc;
  final AnalyticsRepository _analyticsRepository;

  EditJournalEntryBloc(
      {JournalEntryRepository journalEntryRepository,
      @required JournalFeedBloc journalFeedBloc,
      @required AnalyticsRepository analyticsRepository})
      : this._journalEntryRepository =
            journalEntryRepository ?? JournalEntryRepository(),
        this._analyticsRepository = analyticsRepository,
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
        _analyticsRepository.logEvent(name: 'journal_entry_edit');
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
