import 'package:flutter_base_app/src/models/item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ItemState {
  const ItemState(this.items);

  final List<Item> items;
}

class ItemsUnloaded extends ItemState {
  const ItemsUnloaded(List<Item> items) : super(items);
}

class ItemsFetched extends ItemState {
  const ItemsFetched(List<Item> items) : super(items);
}

class ItemsLoading extends ItemState {
  const ItemsLoading(List<Item> items) : super(items);
}

class FetchError extends ItemState {
  const FetchError(List<Item> items) : super(items);
}
