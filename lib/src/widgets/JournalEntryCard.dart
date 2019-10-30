import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/models/JournalEntry.dart';

typedef void OnPressed();

class ItemCard extends StatelessWidget {
  final JournalEntry item;
  final OnPressed onPressed;
  ItemCard({@required this.item, this.onPressed});
  build(context) {
    final theme = Theme.of(context);
    return Card(
      shape: theme.cardTheme.shape,
      color: theme.cardTheme.color,
      margin: theme.cardTheme.margin,
      child: FlatButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.body, style: theme.textTheme.headline),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, top: 8.0),
                    child: Image.network('https://via.placeholder.com/70',
                        height: 70),
                  ),
                  Flexible(
                    child: Column(
                      children: <Widget>[
                        Text(
                          item.description,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
