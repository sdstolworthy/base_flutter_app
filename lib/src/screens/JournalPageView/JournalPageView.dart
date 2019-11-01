import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grateful/src/blocs/pageView/bloc.dart';
import 'package:grateful/src/blocs/pageView/page_view_bloc.dart';
import 'package:grateful/src/screens/EditJournalEntry/EditJournalEntry.dart';
import 'package:grateful/src/screens/JournalEntryFeed/JournalEntryFeed.dart';

// class JournalPageView extends StatefulWidget {
//   createState() => _JournalPageView();
// }

class JournalPageView extends StatelessWidget {
  @override
  final PageViewBloc _pageViewBloc = PageViewBloc();
  Widget build(BuildContext _) {
    return BlocProvider<PageViewBloc>(
        builder: (context) => _pageViewBloc,
        child: BlocBuilder<PageViewBloc, PageViewState>(
            bloc: _pageViewBloc,
            builder: (context, state) {
              if (state is CurrentPage) {
                return Column(children: [
                  Flexible(
                      child: PageView(
                    controller: _pageViewBloc.pageController,
                    children: <Widget>[
                      EditJournalEntry(),
                      JournalEntryFeed(),
                    ],
                  )),
                  Container(
                    color: Theme.of(context).backgroundColor,
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
                ]);
              } else {
                return Container();
              }
            }));
  }
}
