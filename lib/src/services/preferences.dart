import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> getPrefInstance() async {
  return SharedPreferences.getInstance();
}
