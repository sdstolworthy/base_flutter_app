import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/itemFeed/bloc.dart';
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

class _ItemFeedState extends State<ItemFeed> {
  ItemBloc _itemBloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer _refreshCompleter;

  void initState() {
    _itemBloc = ItemBloc(itemRepository: ItemRepository());
    _refreshCompleter = new Completer<void>();

    super.initState();
  }

  void dispose() {
    super.dispose();
    _refreshCompleter.complete();
  }

  build(context) {
    final theme = Theme.of(context);
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            rootNavigationService.navigateTo(
              FlutterAppRoutes.itemEdit,
            );
          },
          child: Icon(Icons.edit),
        ),
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
        body: BlocListener<ItemBloc, ItemState>(
          bloc: _itemBloc,
          listener: (context, state) {
            print(state);
            if (state is ItemsFetched) {
              _refreshCompleter.complete();
              _refreshCompleter = new Completer<void>();
            }
          },
          child: BlocBuilder<ItemBloc, ItemState>(
            bloc: _itemBloc,
            builder: (context, state) {
              if (state is! ItemsFetched && state.items.length == 0) {
                _itemBloc.add(FetchItems());
                return Center(
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
                    itemBuilder: (context, index) {
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
        ));
  }
}
