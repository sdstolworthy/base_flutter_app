import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/Item.dart';
import 'package:flutter_base_app/src/screens/ItemDetails/ItemDetails.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/ItemCard.dart';

class ItemFeed extends StatelessWidget {
  final items = List.generate(20, (_) => Item.random());
  build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: FlatButton(
            child: Icon(Icons.menu, color: Theme.of(context).accentColor),
            onPressed: () {},
          ),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return ItemCard(
              item: items[index],
              onPressed: () {
                navigationService.navigateTo(FlutterAppRoutes.itemDetails,
                    arguments: ItemDetailsArguments(item: items[index]));
              },
            );
          },
          itemCount: items.length,
        ));
  }
}
