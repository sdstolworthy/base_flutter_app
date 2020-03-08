import 'package:flutter_base_app/src/models/item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditItemState {}

class InitialEdititemState extends EditItemState {}

class ItemLoaded extends EditItemState {
  ItemLoaded(this.item);

  final Item item;
}

class ItemSaved extends EditItemState {
  ItemSaved(this.item);

  final Item item;
}

class ItemLoading extends EditItemState {}

class ItemSaveError extends EditItemState {}
