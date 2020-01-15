import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grateful/src/blocs/journal_entry_feed/bloc.dart';
import 'package:grateful/src/blocs/page_view/bloc.dart';
import 'package:grateful/src/models/JournalEntry.dart';
import 'package:grateful/src/screens/journal_entry_details/journal_entry_details.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/drawer.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/journal_feed_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/widgets/no_glow_configuration.dart';
import 'package:grateful/src/widgets/year_separator.dart';

class JournalEntryFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _JournalEntryFeedState();
  }
}

class _JournalEntryFeedState extends State<JournalEntryFeed>
    with TickerProviderStateMixin {
  Completer _refreshCompleter;
  AnimationController _hideFabAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    _refreshCompleter = new Completer<void>();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    super.initState();
  }

  List<Widget> _renderAppBar(BuildContext context, bool isScrolled) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return [
      SliverAppBar(
        floating: true,
        elevation: 0.0,
        title: Text(localizations.previousEntries,
            style: theme.primaryTextTheme.title),
        leading: FlatButton(
          child: Icon(Icons.menu, color: theme.appBarTheme.iconTheme.color),
          onPressed: () {
            _scaffoldKey.currentState.openDrawer();
          },
        ),
      )
    ];
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _hideFabAnimation.forward();
            break;
          case ScrollDirection.reverse:
            _hideFabAnimation.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  Widget renderFab() {
    return ScaleTransition(
      scale: _hideFabAnimation,
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<PageViewBloc>(context).add(SetPage(0));
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  build(context) {
    final _journalFeedBloc = BlocProvider.of<JournalFeedBloc>(context);
    return BlocListener<JournalFeedBloc, JournalFeedState>(
        bloc: _journalFeedBloc,
        listener: (context, state) {
          if (state is JournalFeedFetched) {
            _refreshCompleter.complete();
            _refreshCompleter = new Completer();
          }
        },
        child: Scaffold(
            key: _scaffoldKey,
            floatingActionButton: renderFab(),
            drawer: AppDrawer(),
            body: NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: NestedScrollView(
                headerSliverBuilder: _renderAppBar,
                body: BlocBuilder<JournalFeedBloc, JournalFeedState>(
                  bloc: _journalFeedBloc,
                  builder: (context, state) {
                    if (state is JournalFeedUnloaded) {
                      _journalFeedBloc.add(FetchFeed());
                      return BackgroundGradientProvider(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (state is JournalFeedFetched) {
                      state.journalEntries
                          .sort(_sortJournalEntriesDescendingDate);
                      final Map<int, List<JournalEntry>> sortedEntriesYearMap =
                          _groupEntriesByYear(state.journalEntries);

                      final compiledList =
                          _getJournalEntryListItemWidgets(sortedEntriesYearMap);
                      return BackgroundGradientProvider(
                        child: SafeArea(
                            bottom: false,
                            child: RefreshIndicator(
                              onRefresh: () {
                                _journalFeedBloc.add(FetchFeed());
                                return _refreshCompleter.future;
                              },
                              child: ScrollConfiguration(
                                behavior: NoGlowScroll(showLeading: false),
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return compiledList[index];
                                  },
                                  itemCount: compiledList.length,
                                ),
                              ),
                            )),
                      );
                    }
                    return Container();
                  },
                ),
              ),
            )));
  }

  int _sortJournalEntriesDescendingDate(JournalEntry a, JournalEntry b) {
    return a.date.isBefore(b.date) ? 1 : -1;
  }

  Map<int, List<JournalEntry>> _groupEntriesByYear(
      List<JournalEntry> journalEntries) {
    return journalEntries.fold<Map<int, List<JournalEntry>>>({},
        (previous, current) {
      final year = current.date.year;
      if (previous[year] == null) {
        previous[year] = <JournalEntry>[];
      }
      previous[year].add(current);
      return previous;
    });
  }

  Widget _renderEntryListItem(JournalEntry entry) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: JournalEntryListItem(
        journalEntry: entry,
        onPressed: () {
          rootNavigationService.navigateTo(FlutterAppRoutes.journalEntryDetails,
              arguments: JournalEntryDetailArguments(journalEntry: entry));
        },
      ),
    );
  }

  List<Widget> _getJournalEntryListItemWidgets(
      Map<int, List<JournalEntry>> entriesByYear) {
    return entriesByYear.keys.fold<List<Widget>>([], (p, c) {
      return p
        ..addAll([
          YearSeparator(c.toString()),
          ...entriesByYear[c].map((entry) {
            return _renderEntryListItem(entry);
          })
        ]);
    });
  }
}
