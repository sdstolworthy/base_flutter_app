import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class JournalEntryBloc extends Bloc<JournalFeedEvent, JournalFeedState> {
  @override
  JournalFeedState get initialState => JournalFeedUnloaded();

  final JournalEntryRepository journalEntryRepository;

  JournalEntryBloc({@required this.journalEntryRepository});

  @override
  Stream<JournalFeedState> mapEventToState(
    JournalFeedEvent event,
  ) async* {
    if (event is FetchFeed) {
      final journalEntries = await journalEntryRepository.getFeed();
      yield JournalFeedFetched(journalEntries);
    }
  }
}
