import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/Item.dart';
import 'package:flutter_base_app/src/screens/ItemDetails/ItemDetails.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/AppDrawer/drawer.dart';
import 'package:flutter_base_app/src/widgets/ItemCard.dart';

class ItemFeed extends StatelessWidget {
  final items = List.generate(20, (_) => Item.random());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.edit),
        ),
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.color,
          textTheme: theme.appBarTheme.textTheme,
          leading: FlatButton(
            child: Icon(Icons.menu, color: theme.appBarTheme.iconTheme.color),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer: AppDrawer(),
        body: SafeArea(
            child: ListView.builder(
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
        )));
  }
}
