import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/models/item.dart';
import 'package:flutter_base_app/src/repositories/items/item_repository.dart';
import './bloc.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc({@required this.itemRepository});

  final ItemRepository itemRepository;
  List<Item> previousItems = const <Item>[];

  @override
  ItemState get initialState => const ItemsUnloaded(<Item>[]);

  @override
  Stream<ItemState> mapEventToState(
    ItemEvent event,
  ) async* {
    if (event is FetchItems) {
      yield ItemsLoading(previousItems);
      final List<Item> items = await itemRepository.getItems();
      previousItems = items;
      yield ItemsFetched(items);
    }
  }
}
