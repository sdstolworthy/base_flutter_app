import 'package:grateful/src/models/JournalEntry.dart';
import 'package:meta/meta.dart';

@immutable
abstract class EditItemState {}

class InitialEdititemState extends EditItemState {}

class ItemLoaded extends EditItemState {
  final JournalEntry item;
  ItemLoaded(this.item);
}

class ItemSaved extends EditItemState {
  final JournalEntry item;
  ItemSaved(this.item);
}

class ItemLoading extends EditItemState {}

class ItemSaveError extends EditItemState {}
