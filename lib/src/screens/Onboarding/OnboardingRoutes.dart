import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/screens/Onboarding/Login/LoginScreen.dart';
import 'package:flutter_base_app/src/screens/Onboarding/Welcome/WelcomeScreen.dart';

class _OnboardingNavigation {
  GlobalKey<NavigatorState> onboardingNavigationKey =
      new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {Object arguments}) {
    return onboardingNavigationKey.currentState
        .pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> goBack() async {
    return onboardingNavigationKey.currentState.pop();
  }
}

final onboardingNavigator = _OnboardingNavigation();

class OnboardingRouteNames {
  static const String welcomeScreen = 'welcomeScreen';
  static const String loginScreen = 'loginScreen';
  static const String signupScreen = 'signupScreen';
}

class OnboardingRoutes extends StatelessWidget {
  build(context) {
    return Navigator(
        onGenerateRoute: _generateOnboardingRoutes,
        initialRoute: 'welcomeScreen',
        key: onboardingNavigator.onboardingNavigationKey);
  }

  Route<dynamic> _generateOnboardingRoutes(RouteSettings settings) {
    switch (settings.name) {
      case OnboardingRouteNames.loginScreen:
        return _pageRoute(LoginScreen(true));
      case OnboardingRouteNames.signupScreen:
        return _pageRoute(LoginScreen(false));
      case OnboardingRouteNames.welcomeScreen:
        return _pageRoute(WelcomeScreen());
      default:
        return _pageRoute(WelcomeScreen());
    }
  }

  static _pageRoute(Widget widget) {
    return MaterialPageRoute(builder: (context) => widget);
  }
}
