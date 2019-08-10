import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/screens/CardFeed/CardFeed.dart';
import 'package:flutter_base_app/src/screens/Login/LoginScreen.dart';

class FlutterAppRoutes {
  static const String login = 'login';
}

class Router {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    // else we can go into the good stuff
    switch (settings.name) {
      case FlutterAppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => CardFeed());
    }
  }
}
