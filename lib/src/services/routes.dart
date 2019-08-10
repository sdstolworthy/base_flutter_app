import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_state.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/screens/Login/LoginScreen.dart';

class FlutterAppRoutes {
  static const String login = 'login';
}

class Router {
  static Route<dynamic> generatedRoute(
      RouteSettings settings, AuthenticationState authState) {
    // If we are not authenticated, or the app just started, let's go to the login screen
    if (authState is Unauthenticated || authState is Uninitialized) {
      return MaterialPageRoute(builder: (_) => LoginScreen());
    }
    // else we can go into the good stuff
    switch (settings.name) {
      case FlutterAppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Container(),
                  appBar: AppBar(),
                ));
    }
  }
}
