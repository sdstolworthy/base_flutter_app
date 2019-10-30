import 'package:flutter/material.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';

class ItemDetailsArguments {
  JournalEntry item;

  ItemDetailsArguments({@required this.item});
}

class ItemDetails extends StatelessWidget {
  final JournalEntry journalEntry;
  ItemDetails(this.journalEntry);
  build(context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.appBarTheme.color,
          leading: FlatButton(
              child: Icon(Icons.arrow_back,
                  color: theme.appBarTheme.iconTheme.color),
              onPressed: () {
                rootNavigationService.goBack();
              }),
          actions: <Widget>[
            FlatButton(
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                rootNavigationService.navigateTo(FlutterAppRoutes.itemEdit,
                    arguments:
                        EditJournalEntryArgs(journalEntry: journalEntry));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('', style: theme.textTheme.display1),
                    ],
                  ),
                  // journalEntry.photographs != null
                  //     ? Padding(
                  //         padding: const EdgeInsets.only(top: 20, bottom: 20),
                  //         child: Image.network(journalEntry.photoUrl),
                  //       )
                  //     : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          child: Column(
                        children: <Widget>[
                          Text(journalEntry.description,
                              style: theme.textTheme.subhead),
                        ],
                      )),
                    ],
                  ),
                ],
              )),
        ));
  }
}
