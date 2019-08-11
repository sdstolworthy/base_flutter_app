import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/screens/ItemFeed/ItemFeed.dart';
import 'package:flutter_base_app/src/screens/ItemDetails/ItemDetails.dart';
import 'package:flutter_base_app/src/screens/Login/LoginScreen.dart';

class FlutterAppRoutes {
  static const String login = 'login';
  static const String itemDetails = 'itemDetails';
  static const String itemFeed = 'itemFeed';
}

class Router {
  static _pageRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.login:
        return _pageRoute(LoginScreen());
      case FlutterAppRoutes.itemDetails:
        final ItemDetailsArguments args = settings.arguments;
        return _pageRoute(ItemDetails(args.item));
      case FlutterAppRoutes.itemFeed:
        return _pageRoute(ItemFeed());
      default:
        return _pageRoute(ItemFeed());
    }
  }
}
