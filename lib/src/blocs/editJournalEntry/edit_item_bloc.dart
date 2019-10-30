import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/JournalEntries/JournalEntryRepository.dart';
import './bloc.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final JournalEntryRepository _itemRepository;

  EditItemBloc({JournalEntryRepository itemRepository})
      : this._itemRepository = itemRepository ?? JournalEntryRepository();

  @override
  EditItemState get initialState => InitialEdititemState();

  @override
  Stream<EditItemState> mapEventToState(
    EditItemEvent event,
  ) async* {
    if (event is SaveItem) {
      try {
        yield ItemLoading();
        final item = await _itemRepository.saveItem(event.item);
        yield ItemSaved(item);
      } catch (e) {
        print(e);
        yield ItemSaveError();
      }
    }
  }
}
