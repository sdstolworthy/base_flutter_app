import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class JournalFeedBloc extends Bloc<JournalFeedEvent, JournalFeedState> {
  @override
  JournalFeedState get initialState => JournalFeedUnloaded();

  final JournalEntryRepository journalEntryRepository;

  JournalFeedBloc({@required this.journalEntryRepository});

  @override
  Stream<JournalFeedState> mapEventToState(
    JournalFeedEvent event,
  ) async* {
    if (event is FetchFeed) {
      try {
        final journalEntries = await journalEntryRepository.getFeed();
        if (journalEntries != null) {
          yield JournalFeedFetched(journalEntries);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
