import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/page_view/bloc.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/screens/edit_journal_entry/edit_journal_entry.dart';
import 'package:grateful/src/screens/journal_entry_feed/journal_entry_feed.dart';

enum Page { entryEdit, entryFeed }

const _pageOrder = <Page>[Page.entryEdit, Page.entryFeed];

class JournalPageArguments {
  final Page page;
  final JournalEntry entry;
  final bool isEdit;

  JournalPageArguments({page, entry})
      : page = page ?? Page.entryEdit,
        entry = entry ?? null,
        isEdit = entry != null;
}

class JournalPageView extends StatefulWidget {
  final Page initialPage;
  final JournalEntry journalEntry;
  JournalPageView({initialPage, journalEntry})
      : initialPage = initialPage ?? Page.entryEdit,
        journalEntry = journalEntry ?? null;
  createState() =>
      _JournalPageView(initialPage: initialPage, journalEntry: journalEntry);
}

class _JournalPageView extends State<JournalPageView> {
  final Page initialPage;
  final JournalEntry journalEntry;
  _JournalPageView({this.initialPage, this.journalEntry});

  PageViewBloc _pageViewBloc = PageViewBloc();
  bool isActive;
  StreamSubscription<void> activeCanceller;
  void initState() {
    setActive(true);
    _pageViewBloc =
        PageViewBloc(initialPage: _pageOrder.indexOf(this.initialPage) ?? 0);
    super.initState();
  }

  void setActive(active) {
    setState(() {
      isActive = active;
    });
    if (active == true) {
      activeCanceller?.cancel();
      activeCanceller =
          Future.delayed(const Duration(seconds: 2)).asStream().listen((_) {
        if (this.mounted) {
          setState(() {
            setActive(false);
          });
        }
      });
    }
  }


  Widget build(BuildContext c) {
    return BlocProvider<PageViewBloc>(
        create: (context) => _pageViewBloc,
        child: BlocBuilder<PageViewBloc, PageViewState>(
            bloc: _pageViewBloc,
            builder: (context, state) {
              _pageViewBloc.pageController.addListener(() {
                /// When changing pages, hide the keyboard
                FocusScope.of(context).requestFocus(new FocusNode());
              });
              if (state is CurrentPage) {
                return GestureDetector(
                  onTapDown: (_) {
                    setActive(true);
                  },
                  child: Stack(children: [
                    PageView(
                      controller: _pageViewBloc.pageController,
                      children: <Widget>[
                        EditJournalEntry(item: journalEntry),
                        JournalEntryFeed(),
                      ],
                    ),
                  ]),
                );
              } else {
                return Container();
              }
            }));
  }
}
