import 'package:flutter/material.dart';
import 'package:grateful/src/grateful.dart';
import 'package:grateful/src/config/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final configuredApp = new AppEnvironment(
    child: FlutterApp(),
    cloudStorageBucket: 'gs://grateful-journal.appspot.com/',
  );
  runApp(configuredApp);
}
