import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class JournalEntryBloc extends Bloc<ItemEvent, JournalFeedState> {
  @override
  JournalFeedState get initialState => JournalFeedUnloaded();

  final JournalEntryRepository itemRepository;

  JournalEntryBloc({@required this.itemRepository});

  @override
  Stream<JournalFeedState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is FetchItems) {
      final items = await itemRepository.getItems();
      yield JournalFeedFetched(items);
    }
  }
}
