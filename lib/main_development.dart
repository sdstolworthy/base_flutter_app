import 'package:flutter/material.dart';
import 'package:grateful/src/Grateful.dart';
import 'package:grateful/src/config/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final configuredApp = new AppEnvironment(
    child: FlutterApp(),
    cloudStorageBucket: 'gs://dev-gratitude-journal.appspot.com/',
  );
  runApp(configuredApp);
}
