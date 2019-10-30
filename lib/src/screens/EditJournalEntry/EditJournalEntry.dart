import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/editJournalEntry/bloc.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/widgets/DateSelectorButton.dart';
import 'package:grateful/src/widgets/JournalEntryInput.dart';

class EditJournalEntryArgs {
  JournalEntry journalEntry;

  EditJournalEntryArgs({this.journalEntry});
}

class EditItem extends StatefulWidget {
  final JournalEntry item;
  EditItem({JournalEntry item}) : this.item = item ?? JournalEntry();
  @override
  State<StatefulWidget> createState() {
    return _EditItemState(item: this.item);
  }
}

class _EditItemState extends State<EditItem> {
  JournalEntry item;
  final EditItemBloc _editItemBloc = EditItemBloc();

  final TextEditingController _journalEntryController = TextEditingController();

  DateTime selectedDate;

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
        builder: (BuildContext context, EditItemState state) {
          if (state is EditItemState) {
            _journalEntryController.text = '';
            selectedDate = selectedDate ??
                DateTime.fromMillisecondsSinceEpoch(
                    DateTime.now().millisecondsSinceEpoch);
          } else {
            selectedDate = selectedDate ?? DateTime.now();
          }
          return Scaffold(
              drawer: Drawer(child: Container()),
              body: Container(
                color: Theme.of(context).backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'What are you grateful for today?',
                          style: TextStyle(color: Colors.white, fontSize: 24.0),
                          textAlign: TextAlign.center,
                        ),
                        DateSelectorButton(
                          onPressed: handlePickDate,
                          selectedDate: selectedDate,
                        ),
                        SizedBox(height: 10),
                        IconButton(
                          iconSize: 36.0,
                          icon: Icon(Icons.arrow_forward),
                          color: Colors.white,
                          onPressed: () {},
                        ),
                        JournalInput(_journalEntryController),
                        SizedBox(
                          height: 150,
                        ),
                      ]),
                ),
              ));
        });
  }

  void handlePickDate(context) async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.parse('1900-01-01'),
      lastDate: DateTime.now(),
    );
    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }
  // return BlocBuilder(
  //     bloc: _editItemBloc,
  //     builder: (context, state) {
  //       return Scaffold(
  //         appBar: AppBar(
  //           title: Text('Edit Entry'),
  //         ),
  //         body: SafeArea(
  //           child: state is ItemLoading
  //               ? Center(
  //                   child: CircularProgressIndicator(),
  //                 )
  //               : ListView(
  //                   padding: EdgeInsets.only(left: 20, right: 20),
  //                   children: <Widget>[
  //                     SizedBox(height: 20),
  //                     TextFormField(
  //                       initialValue: item.title,
  //                       decoration: InputDecoration(labelText: 'Item Title'),
  //                       onChanged: (t) {
  //                         item.title = t;
  //                       },
  //                     ),
  //                     TextFormField(
  //                       initialValue: item.description,
  //                       decoration:
  //                           InputDecoration(labelText: 'Item Description'),
  //                       onChanged: (t) {
  //                         item.description = t;
  //                       },
  //                     ),
  //                     TextFormField(
  //                       initialValue: item.photoUrl,
  //                       decoration: InputDecoration(labelText: 'Photo Url'),
  //                       onChanged: (t) {
  //                         item.photoUrl = t;
  //                       },
  //                     ),
  //                     RaisedButton(
  //                       onPressed: () {
  //                         _editItemBloc.add(SaveItem(item));
  //                       },
  //                       child: Text('Submit'),
  //                     )
  //                   ],
  //                 ),
  //         ),
  //       );
  //     });

}
