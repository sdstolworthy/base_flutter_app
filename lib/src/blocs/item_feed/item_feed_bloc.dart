import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/models/Item.dart';
import 'package:flutter_base_app/src/repositories/items/item_repository.dart';
import './bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  @override
  ItemState get initialState => ItemsUnloaded([]);

  List<Item> previousItems = [];

  final ItemRepository itemRepository;

  ItemBloc({@required this.itemRepository});

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is FetchItems) {
      yield ItemsLoading(previousItems);
      final items = await itemRepository.getItems();
      previousItems = items;
      yield ItemsFetched(items);
    }
  }
}
