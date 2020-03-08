import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/services/routes.dart';

class _RootNavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return navigatorKey.currentState.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> pushReplacementNamed(String routeName, {Object arguments}) {
    return navigatorKey.currentState
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<dynamic> returnToLogin() async {
    await navigatorKey.currentState
        .pushNamedAndRemoveUntil(FlutterAppRoutes.welcomeScreen, (_) => false);
  }

  Future<dynamic> goBack() async {
    return navigatorKey.currentState.pop();
  }

  Future<dynamic> pushNamedAndRemoveUntil(
      String routeName, bool Function(Route<dynamic>) predicate) async {
    navigatorKey.currentState.pushNamedAndRemoveUntil(routeName, predicate);
  }
}

final _RootNavigationService rootNavigationService = _RootNavigationService();
