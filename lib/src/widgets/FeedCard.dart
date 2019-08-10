import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class FeedCard extends StatelessWidget {
  build(_) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(faker.lorem.word(),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                        faker.lorem.words(20).fold('',
                            (String prev, String curr) {
                          return prev + ' ' + curr;
                        }),
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
    );
  }
}
