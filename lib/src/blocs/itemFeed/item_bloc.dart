import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:spencerstolworthy_goals/src/repositories/items/itemRepository.dart';
import './bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  @override
  ItemState get initialState => ItemsUnloaded();

  final ItemRepository itemRepository;

  ItemBloc({@required this.itemRepository});

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is FetchItems) {
      final items = await itemRepository.getItems();
      yield ItemsFetched(items);
    }
  }
}
