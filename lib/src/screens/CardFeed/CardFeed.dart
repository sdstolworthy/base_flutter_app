import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/widgets/FeedCard.dart';

class CardFeed extends StatelessWidget {
  build(context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          leading: FlatButton(
            child: Icon(Icons.menu),
            onPressed: () {},
          ),
        ),
        body: ListView(
          children: List.generate(20, (_) => FeedCard()),
        ));
  }
}
