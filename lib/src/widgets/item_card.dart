import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/models/item.dart';

typedef OnPressed = void Function();

class ItemCard extends StatelessWidget {
  const ItemCard({@required this.item, this.onPressed});

  final Item item;
  final OnPressed onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
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
              Text(item.title, style: theme.textTheme.headline),
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
