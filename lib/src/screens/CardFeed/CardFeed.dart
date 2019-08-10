import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/widgets/FeedCard.dart';

class CardFeed extends StatelessWidget {
  build(_) {
    return Scaffold(
        body: ListView(
      children: List.generate(20, (_) => FeedCard()),
    ));
  }
}
