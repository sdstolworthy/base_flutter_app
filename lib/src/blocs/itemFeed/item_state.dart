import 'package:flutter_base_app/src/models/Item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemState {
  final List<Item> items;
  ItemState(this.items);
}

class ItemsUnloaded extends ItemState {
  ItemsUnloaded(List<Item> items) : super(items);
}

class ItemsFetched extends ItemState {
  ItemsFetched(List<Item> items) : super(items);
}

class ItemsLoading extends ItemState {
  ItemsLoading(List<Item> items) : super(items);
}

class FetchError extends ItemState {
  FetchError(List<Item> items) : super(items);
}
