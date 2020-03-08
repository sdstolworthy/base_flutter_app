import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_state.dart';
import 'package:flutter_base_app/src/services/loading_tasks/loading_task.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';

class AuthenticationListener extends StatelessWidget {
  const AuthenticationListener({@required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: authenticationBloc,
      condition: (AuthenticationState previousState,
          AuthenticationState currentState) {
        if (previousState is! Authenticated && currentState is Authenticated) {
          return true;
        }
        if (previousState is! Unauthenticated &&
            currentState is Unauthenticated) {
          return true;
        }
        return false;
      },
      listener: (BuildContext context, AuthenticationState state) {
        final List<Future<dynamic>> preAuthenticationHookFutures =
            getPreAuthenticationHooks(context)
                .map((LoadingTask hook) => hook.execute())
                .toList();
        try {
          if (state is Unauthenticated) {
            rootNavigationService.returnToLogin();
          } else if (state is Authenticated) {
            Future.wait<void>(<Future<dynamic>>[
              ...getPostAuthenticationHooks(context)
                  .map<Future<dynamic>>((LoadingTask hook) => hook.execute()),
              ...preAuthenticationHookFutures
            ]).then((_) {
              rootNavigationService.pushNamedAndRemoveUntil(
                  FlutterAppRoutes.itemFeed, (Route<dynamic> route) => false);
            });
          } else {
            Future.wait<void>(preAuthenticationHookFutures).then((_) {
              rootNavigationService.returnToLogin();
            });
          }
        } catch (e) {
          print(e);
          rootNavigationService.returnToLogin();
        }
      },
      child: child,
    );
  }
}
