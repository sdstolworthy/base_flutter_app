import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/theme/theme.dart';
import 'package:flutter_base_app/src/widgets/BlocProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlutterApp extends StatelessWidget {
  build(_) {
    return AppBlocProviders(child: Builder(builder: (context) {
      AuthenticationBloc authState =
          BlocProvider.of<AuthenticationBloc>(context);
      return MaterialApp(
        theme: flutterAppTheme,
        onGenerateRoute: (RouteSettings settings) {
          return Router.generatedRoute(settings, authState.currentState);
        },
        navigatorKey: navigationService.navigatorKey,
      );
    }));
  }
}
