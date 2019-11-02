import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/pageView/bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_bloc.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/screens/JournalEntryFeed/JournalEntryFeed.dart';

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

class _JournalPageView extends State<JournalPageView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
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
        setState(() {
          setActive(false);
        });
      });
    }
  }

  Widget build(BuildContext c) {
    return BlocProvider<PageViewBloc>(
        builder: (context) => _pageViewBloc,
        child: BlocBuilder<PageViewBloc, PageViewState>(
            bloc: _pageViewBloc,
            builder: (context, state) {
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
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 100),
                      bottom: isActive == true ? 0 : -100,
                      right: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.black, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter)),
                        child: BottomNavigationBar(
                          unselectedItemColor: Colors.grey[600],
                          backgroundColor: Colors.transparent,
                          elevation: 100,
                          currentIndex: state.pageIndex,
                          onTap: (index) {
                            _pageViewBloc.add(SetPage(index));
                          },
                          items: [
                            BottomNavigationBarItem(
                                icon: Icon(Icons.edit),
                                title: Text('Write something new')),
                            BottomNavigationBarItem(
                                icon: Icon(Icons.list),
                                title: Text('See past entries'))
                          ],
                        ),
                      ),
                    )
                  ]),
                );
              } else {
                return Container();
              }
            }));
  }
}
