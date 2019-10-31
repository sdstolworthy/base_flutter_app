import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class JournalEntryBloc extends Bloc<JournalFeedEvent, JournalFeedState> {
  @override
  JournalFeedState get initialState => JournalFeedUnloaded();

  final JournalEntryRepository itemRepository;

  JournalEntryBloc({@required this.itemRepository});

  @override
  Stream<JournalFeedState> mapEventToState(
    JournalFeedEvent event,
  ) async* {
    if (event is FetchFeed) {
      final journalEntries = await itemRepository.getFeed();
      yield JournalFeedFetched(journalEntries);
    }
  }
}
