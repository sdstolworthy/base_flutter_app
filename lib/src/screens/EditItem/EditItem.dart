import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/editItem/bloc.dart';
import 'package:flutter_base_app/src/models/Item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditItemArgs {
  Item item;

  EditItemArgs({this.item});
}

class EditItem extends StatefulWidget {
  final Item item;
  EditItem({Item item}) : this.item = item ?? Item();
  @override
  State<StatefulWidget> createState() {
    return _EditItemState(item: this.item);
  }
}

class _EditItemState extends State<EditItem> {
  Item item;
  final EditItemBloc _editItemBloc = EditItemBloc();
  _EditItemState({this.item});
  initState() {
    super.initState();
  }

  dispose() {
    _editItemBloc.close();
    super.dispose();
  }

  build(_) {
    return BlocBuilder(
        bloc: _editItemBloc,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Entry'),
            ),
            body: SafeArea(
              child: state is ItemLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      children: <Widget>[
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: item.title,
                          decoration: InputDecoration(labelText: 'Item Title'),
                          onChanged: (t) {
                            item.title = t;
                          },
                        ),
                        TextFormField(
                          initialValue: item.description,
                          decoration:
                              InputDecoration(labelText: 'Item Description'),
                          onChanged: (t) {
                            item.description = t;
                          },
                        ),
                        TextFormField(
                          initialValue: item.photoUrl,
                          decoration: InputDecoration(labelText: 'Photo Url'),
                          onChanged: (t) {
                            item.photoUrl = t;
                          },
                        ),
                        RaisedButton(
                          onPressed: () {
                            _editItemBloc.add(SaveItem(item));
                          },
                          child: Text('Submit'),
                        )
                      ],
                    ),
            ),
          );
        });
  }
}
