import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_base_app/src/blocs/item_feed/bloc.dart';
import 'package:flutter_base_app/src/repositories/items/item_repository.dart';
import 'package:flutter_base_app/src/screens/item_details/item_details.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/app_drawer/drawer.dart';
import 'package:flutter_base_app/src/widgets/item_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemFeedState();
  }
}

class _ItemFeedState extends State<ItemFeed> with TickerProviderStateMixin {
  ItemBloc _itemBloc;
  AnimationController _hideFabAnimation;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    _itemBloc = ItemBloc(itemRepository: ItemRepository());
    _refreshCompleter = Completer<void>();
    _hideFabAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFabAnimation.forward();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshCompleter.complete();
  }

  Widget _renderFab() {
    return ScaleTransition(
      scale: _hideFabAnimation,
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        onPressed: () {
          rootNavigationService.navigateTo(
            FlutterAppRoutes.itemEdit,
          );
        },
        child: Icon(Icons.edit),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: _renderFab(),
        appBar: AppBar(
          backgroundColor: theme.appBarTheme.color,
          textTheme: theme.appBarTheme.textTheme,
          leading: FlatButton(
            child: Icon(Icons.menu, color: theme.appBarTheme.iconTheme.color),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
        ),
        drawer: AppDrawer(),
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: BlocListener<ItemBloc, ItemState>(
            bloc: _itemBloc,
            listener: (BuildContext context, ItemState state) {
              if (state is ItemsFetched) {
                _refreshCompleter.complete();
                _refreshCompleter = Completer<void>();
              }
            },
            child: BlocBuilder<ItemBloc, ItemState>(
              bloc: _itemBloc,
              builder: (BuildContext context, ItemState state) {
                if (state is! ItemsFetched && state.items.isEmpty) {
                  _itemBloc.add(FetchItems());
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: () {
                      _itemBloc.add(FetchItems());
                      return _refreshCompleter.future;
                    },
                    child: SafeArea(
                        child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return ItemCard(
                          item: state.items[index],
                          onPressed: () {
                            rootNavigationService.navigateTo(
                                FlutterAppRoutes.itemDetails,
                                arguments: ItemDetailsArguments(
                                    item: state.items[index]));
                          },
                        );
                      },
                      itemCount: state.items.length,
                    )),
                  );
                }
              },
            ),
          ),
        ));
  }
}
