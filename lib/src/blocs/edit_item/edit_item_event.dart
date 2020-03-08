import 'package:flutter_base_app/src/models/item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditItemEvent {}

class SaveItem extends EditItemEvent {
  SaveItem(this.item);

  final Item item;
}
