import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_bloc.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/screens/JournalEntryFeed/JournalEntryFeed.dart';

class JournalPageView extends StatefulWidget {
  createState() => _JournalPageView();
}

class _JournalPageView extends State<JournalPageView> {
  @override
  final PageViewBloc _pageViewBloc = PageViewBloc();
  Widget build(BuildContext context) {
    return BlocProvider<PageViewBloc>(
        builder: (context) => _pageViewBloc,
        child: PageView(
          controller: _pageViewBloc.pageController,
          children: <Widget>[
            EditJournalEntry(),
            JournalEntryFeed(),
          ],
        ));
  }
}
