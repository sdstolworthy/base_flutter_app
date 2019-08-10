import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';

class FlutterApp extends StatelessWidget {
  build(context) {
    return MaterialApp(
      onGenerateRoute: Router.generatedRoute,
      navigatorKey: navigationService.navigatorKey,
    );
  }
}
