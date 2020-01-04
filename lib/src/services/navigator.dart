import 'package:flutter/widgets.dart';
import 'package:spencerstolworthy_goals/src/services/routes.dart';

class _RootNavigationService {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> returnToLogin() async {
    await navigatorKey.currentState
        .pushReplacementNamed(FlutterAppRoutes.onboarding);
  }

  Future<dynamic> goBack() async {
    return navigatorKey.currentState.pop();
  }
}

final rootNavigationService = new _RootNavigationService();
