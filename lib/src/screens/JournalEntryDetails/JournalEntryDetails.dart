import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';

class JournalEntryDetailArguments {
  JournalEntry journalEntry;

  JournalEntryDetailArguments({@required this.journalEntry});
}

class JournalEntryDetails extends StatelessWidget {
  final JournalEntry journalEntry;
  JournalEntryDetails(this.journalEntry);
  build(context) {
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
              rootNavigationService.navigateTo(
                  FlutterAppRoutes.editJournalEntry,
                  arguments: EditJournalEntryArgs(journalEntry: journalEntry));
            },
          )
        ],
      ),
      body: LayoutBuilder(builder: (context, viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Container(
              color: theme.backgroundColor,
              child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('', style: theme.primaryTextTheme.headline),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Column(
                            children: <Widget>[
                              Text(journalEntry.body ?? '',
                                  style: theme.primaryTextTheme.body1),
                            ],
                          )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: journalEntry.photographs != null &&
                                journalEntry.photographs.length > 0
                            ? CarouselSlider(
                                height: 150,
                                viewportFraction: 0.5,
                                enableInfiniteScroll: false,
                                items: <Widget>[
                                  ...journalEntry.photographs
                                      .map((p) => Image.network(p.imageUrl))
                                      .toList()
                                ],
                              )
                            : Container(),
                      ),
                    ],
                  )),
            ),
          ),
        );
      }),
    );
  }
}
