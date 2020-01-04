import 'package:spencerstolworthy_goals/src/models/Item.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditItemEvent {}

class SaveItem extends EditItemEvent {
  final Item item;
  SaveItem(this.item);
}
