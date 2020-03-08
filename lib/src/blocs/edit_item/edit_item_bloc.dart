import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_base_app/src/models/item.dart';
import 'package:flutter_base_app/src/repositories/items/item_repository.dart';
import './bloc.dart';

class EditItemBloc extends Bloc<EditItemEvent, EditItemState> {
  EditItemBloc({ItemRepository itemRepository})
      : _itemRepository = itemRepository ?? ItemRepository();

  final ItemRepository _itemRepository;

  @override
  EditItemState get initialState => InitialEdititemState();

  @override
  Stream<EditItemState> mapEventToState(
    EditItemEvent event,
  ) async* {
    if (event is SaveItem) {
      try {
        yield ItemLoading();
        final Item item = await _itemRepository.saveItem(event.item);
        yield ItemSaved(item);
      } catch (e) {
        print(e);
        yield ItemSaveError();
      }
    }
  }
}
