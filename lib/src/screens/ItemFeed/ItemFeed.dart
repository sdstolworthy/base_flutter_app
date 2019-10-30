import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/itemFeed/bloc.dart';
import 'package:grateful/src/repositories/items/itemRepository.dart';
import 'package:grateful/src/screens/ItemDetails/ItemDetails.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/AppDrawer/drawer.dart';
import 'package:grateful/src/widgets/ItemCard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemFeed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ItemFeedState();
  }
}

class _ItemFeedState extends State<ItemFeed> {
  // final items = List.generate(20, (_) => Item.random());
  ItemBloc _itemBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void initState() {
    _itemBloc = ItemBloc(itemRepository: ItemRepository());
    super.initState();
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
        body: BlocBuilder<ItemBloc, ItemState>(
          bloc: _itemBloc,
          builder: (context, state) {
            if (state is ItemsUnloaded) {
              _itemBloc.add(FetchItems());
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ItemsFetched) {
              return SafeArea(
                  child: ListView.builder(
                itemBuilder: (context, index) {
                  return ItemCard(
                    item: state.items[index],
                    onPressed: () {
                      rootNavigationService.navigateTo(
                          FlutterAppRoutes.itemDetails,
                          arguments:
                              ItemDetailsArguments(item: state.items[index]));
                    },
                  );
                },
                itemCount: state.items.length,
              ));
            }
            return Container();
          },
        ));
  }
}
