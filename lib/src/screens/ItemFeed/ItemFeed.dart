import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/Item.dart';
import 'package:flutter_base_app/src/screens/ItemDetails/ItemDetails.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/ItemCard.dart';
import 'package:flutter_base_app/src/widgets/LanguagePicker.dart';

class ItemFeed extends StatelessWidget {
  final items = List.generate(20, (_) => Item.random());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  build(context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: FlatButton(
            child: Icon(Icons.menu, color: Theme.of(context).accentColor),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer: Drawer(
          child: LanguagePicker(),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ItemCard(
              item: items[index],
              onPressed: () {
                rootNavigationService.navigateTo(FlutterAppRoutes.itemDetails,
                    arguments: ItemDetailsArguments(item: items[index]));
              },
            );
          },
          itemCount: items.length,
        ));
  }
}
