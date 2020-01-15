import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AppEnvironment extends InheritedWidget {
  AppEnvironment({@required this.cloudStorageBucket, @required Widget child})
      : super(child: child);

  final String cloudStorageBucket;

  static AppEnvironment of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppEnvironment>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
