import 'package:flutter/widgets.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/screens/Login/LoginScreen.dart';

class AuthenticationFilter extends StatelessWidget {
  final Widget child;
  final AuthenticationState state;
  AuthenticationFilter({@required this.child, @required this.state});

  build(_) {
    if (state is Unauthenticated || state is Uninitialized) {
      return LoginScreen();
    } else {
      return child;
    }
  }
}
