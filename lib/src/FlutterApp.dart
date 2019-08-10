import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/authentication_bloc.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/theme/theme.dart';
import 'package:flutter_base_app/src/widgets/AuthenticationFilter.dart';
import 'package:flutter_base_app/src/widgets/BlocProvider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlutterApp extends StatelessWidget {
  build(_) {
    return AppBlocProviders(child: Builder(builder: (context) {
      AuthenticationBloc authState =
          BlocProvider.of<AuthenticationBloc>(context);
      return BlocBuilder(
        bloc: authState,
        builder: (authBlocContext, state) {
          return MaterialApp(
              theme: flutterAppTheme,
              home: AuthenticationFilter(
                  state: state,
                  child: Navigator(
                      onGenerateRoute: Router.generatedRoute,
                      key: navigationService.navigatorKey)));
        },
      );
    }));
  }
}
