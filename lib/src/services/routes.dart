import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/screens/ItemFeed/ItemFeed.dart';
import 'package:flutter_base_app/src/screens/ItemDetails/ItemDetails.dart';
import 'package:flutter_base_app/src/screens/Login/LoginScreen.dart';
import 'package:flutter_base_app/src/screens/Welcome/WelcomeScreen.dart';

class FlutterAppRoutes {
  static const String login = 'login';
  static const String itemDetails = 'itemDetails';
  static const String itemFeed = 'itemFeed';
  static const String welcome = 'welcome';
}

typedef Route CurriedRouter(RouteSettings settings);

class Router {
  static _pageRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }

  static generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.login:
        final LoginScreenArguments args = settings.arguments;
        return _pageRoute(LoginScreen(args.isLogin));
      case FlutterAppRoutes.itemDetails:
        final ItemDetailsArguments args = settings.arguments;
        return _pageRoute(ItemDetails(args.item));
      case FlutterAppRoutes.itemFeed:
        return _pageRoute(ItemFeed());
      default:
        return _pageRoute(WelcomeScreen());
    }
  }
}
