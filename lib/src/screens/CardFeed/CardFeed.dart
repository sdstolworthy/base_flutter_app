import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/widgets/FeedCard.dart';

class CardFeed extends StatelessWidget {
  build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: FlatButton(
            child: Icon(Icons.menu, color: Theme.of(context).accentColor),
            onPressed: () {},
          ),
        ),
        body: ListView(
          children: List.generate(20, (_) => FeedCard()),
        ));
  }
}
