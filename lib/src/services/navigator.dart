import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/services/routes.dart';

class _NavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> returnToLogin() async {
    return navigatorKey.currentState
        .popUntil(ModalRoute.withName(FlutterAppRoutes.login));
  }
}

final navigationService = new _NavigationService();
