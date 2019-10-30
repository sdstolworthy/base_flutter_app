import 'package:grateful/src/models/JournalEntry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditItemEvent {}

class SaveItem extends EditItemEvent {
  final JournalEntry item;
  SaveItem(this.item);
}
