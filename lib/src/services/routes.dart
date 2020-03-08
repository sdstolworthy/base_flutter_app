import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/screens/edit_item/edit_item.dart';
import 'package:flutter_base_app/src/screens/item_feed/item_feed.dart';
import 'package:flutter_base_app/src/screens/item_details/item_details.dart';
import 'package:flutter_base_app/src/screens/user_profile/user_profile_screen.dart';
import 'package:flutter_base_app/src/theme/theme.dart';
import 'package:flutter_base_app/src/screens/feedback_form/feedback_form.dart';
import 'package:flutter_base_app/src/screens/welcome/welcome_screen.dart';
import 'package:flutter_base_app/src/screens/login/login_screen.dart';

class FlutterAppRoutes {
  static const String itemDetails = 'itemDetails';
  static const String itemFeed = 'itemFeed';
  static const String welcome = 'welcome';
  static const String onboarding = 'onboarding';
  static const String itemEdit = 'itemEdit';
  static const String welcomeScreen = 'welcomeScreen';
  static const String loginScreen = 'loginScreen';
  static const String signupScreen = 'signupScreen';
  static const String userProfileScreen = 'userProfileScreen';
  static const String feedback = 'feedback';
}

typedef Route CurriedRouter(RouteSettings settings);

class Router {
  static _pageRoute(Widget widget, String routeName) {
    return PageRouteBuilder(
        pageBuilder: (c, a, s) =>
            Theme(data: baseAppTheme(Theme.of(c)), child: widget),
        transitionsBuilder: (c, a, s, child) {
          return SlideTransition(
            child: child,
            position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(a),
          );
        },
        settings: RouteSettings(name: routeName));
  }

  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case FlutterAppRoutes.itemDetails:
        final ItemDetailsArguments args = settings.arguments;
        return _pageRoute(ItemDetails(args.item), FlutterAppRoutes.itemDetails);
      case FlutterAppRoutes.itemFeed:
        return _pageRoute(ItemFeed(), FlutterAppRoutes.itemFeed);
      case FlutterAppRoutes.loginScreen:
        return _pageRoute(LoginScreen(true), FlutterAppRoutes.loginScreen);
      case FlutterAppRoutes.signupScreen:
        return _pageRoute(LoginScreen(false), FlutterAppRoutes.signupScreen);
      case FlutterAppRoutes.welcomeScreen:
        return _pageRoute(WelcomeScreen(), FlutterAppRoutes.welcomeScreen);
      case FlutterAppRoutes.userProfileScreen:
        return _pageRoute(
            UserProfileScreen(), FlutterAppRoutes.userProfileScreen);
      case FlutterAppRoutes.itemEdit:
        final EditItemArgs args = settings.arguments;
        return _pageRoute(
            EditItem(item: args?.item), FlutterAppRoutes.itemEdit);
      case FlutterAppRoutes.feedback:
        final FeedbackFormArgs feedbackFormArgs = settings.arguments;
        return _pageRoute(FeedbackForm(feedbackFormArgs), FlutterAppRoutes.feedback);
      default:
        return _pageRoute(WelcomeScreen(), FlutterAppRoutes.onboarding);
    }
  }
}
