import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/edit_item/bloc.dart';
import 'package:flutter_base_app/src/models/item.dart';
import 'package:flutter_base_app/src/screens/item_details/item_details.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditItemArgs {
  EditItemArgs({this.item});

  Item item;
}

class EditItem extends StatefulWidget {
  EditItem({Item item}) : item = item ?? Item();

  final Item item;

  @override
  State<StatefulWidget> createState() {
    return _EditItemState(item: item);
  }
}

class _EditItemState extends State<EditItem> {
  _EditItemState({this.item});

  Item item;

  final EditItemBloc _editItemBloc = EditItemBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _editItemBloc.close();
    super.dispose();
  }

  @override
  Widget build(_) {
    return BlocBuilder<EditItemBloc, EditItemState>(
        bloc: _editItemBloc,
        builder: (BuildContext context, EditItemState state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Entry'),
            ),
            body: SafeArea(
              child: state is ItemLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      children: <Widget>[
                        const SizedBox(height: 20),
                        TextFormField(
                          initialValue: item.title,
                          decoration:
                              const InputDecoration(labelText: 'Item Title'),
                          onChanged: (String t) {
                            item.title = t;
                          },
                        ),
                        TextFormField(
                          initialValue: item.description,
                          decoration: const InputDecoration(
                              labelText: 'Item Description'),
                          onChanged: (String t) {
                            item.description = t;
                          },
                        ),
                        TextFormField(
                          initialValue: item.photoUrl,
                          decoration:
                              const InputDecoration(labelText: 'Photo Url'),
                          onChanged: (String t) {
                            item.photoUrl = t;
                          },
                        ),
                        RaisedButton(
                          onPressed: () {
                            _editItemBloc.add(SaveItem(item));
                            rootNavigationService.pushReplacementNamed(
                                FlutterAppRoutes.itemDetails,
                                arguments: ItemDetailsArguments(item: item));
                          },
                          child: const Text('Submit'),
                        )
                      ],
                    ),
            ),
          );
        });
  }
}
