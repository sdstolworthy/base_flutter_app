import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_base_app/src/repositories/items/itemRepository.dart';
import './bloc.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  final ItemRepository _itemRepository;

  EditItemBloc({ItemRepository itemRepository})
      : this._itemRepository = itemRepository ?? ItemRepository();

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
