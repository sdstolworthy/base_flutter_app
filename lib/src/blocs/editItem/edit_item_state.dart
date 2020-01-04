import 'package:spencerstolworthy_goals/src/models/Item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditItemState {}

class InitialEdititemState extends EditItemState {}

class ItemLoaded extends EditItemState {
  final Item item;
  ItemLoaded(this.item);
}

class ItemSaved extends EditItemState {
  final Item item;
  ItemSaved(this.item);
}

class ItemLoading extends EditItemState {}

class ItemSaveError extends EditItemState {}
