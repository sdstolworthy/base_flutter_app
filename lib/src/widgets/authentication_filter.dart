import 'package:flutter/widgets.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';

class AuthenticationFilter extends StatelessWidget {
  final Widget authenticatedNavigator;
  // final Widget unauthenticatedNavigator;
  final AuthenticationState state;
  AuthenticationFilter(
      {@required this.authenticatedNavigator,
      // @required this.unauthenticatedNavigator,
      @required this.state});

  build(_) {
    // if (state is Unauthenticated || state is Uninitialized) {
    return authenticatedNavigator;
    //   return WelcomeScreen();
    // } else {
    //   return authenticatedNavigator;
    // }
  }
}
