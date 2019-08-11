import 'package:flutter_base_app/src/config/constants.dart';
import 'package:flutter_base_app/src/models/User.dart';
import 'package:flutter_base_app/src/services/preferences.dart';

class UserRepository {
  Future<User> signIn(String username, String password) async {
    return new User.random();
  }

  Future<bool> isSignedIn() async {
    final prefs = await getPrefInstance();
    return prefs.getString(Constants.tokenStorageKey) != null;
  }

  Future<void> logOut() async {
    final prefs = await getPrefInstance();
    prefs.setString(Constants.tokenStorageKey, null);
  }
}
