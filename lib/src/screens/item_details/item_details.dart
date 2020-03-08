import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/item.dart';
import 'package:flutter_base_app/src/screens/edit_item/edit_item.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';

class ItemDetailsArguments {
  ItemDetailsArguments({@required this.item});

  Item item;
}

class ItemDetails extends StatelessWidget {
  const ItemDetails(this.item);

  final Item item;

  @override
  Widget build(BuildContext context) {
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
                    arguments: EditItemArgs(item: item));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(item.title, style: theme.textTheme.display1),
                    ],
                  ),
                  if (item.photoUrl != null) Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Image.network(item.photoUrl),
                        ) else Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          child: Column(
                        children: <Widget>[
                          Text(item.description,
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
