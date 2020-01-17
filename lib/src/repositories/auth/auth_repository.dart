import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_base_app/src/models/User.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseAnalytics _analytics;

  AuthRepository(
      {FirebaseAuth firebaseAuth,
      GoogleSignIn googleSignIn,
      FirebaseAnalytics analytics})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _analytics = analytics ?? FirebaseAnalytics();

  Future<User> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    return _getUserFromAuthResult(authResult);
  }

  Future<User> signInWithCredentials(String email, String password) async {
    _analytics.logLogin(loginMethod: 'email');
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return _getUserFromAuthResult(authResult);
  }

  Future<User> signUp({String email, String password}) async {
    _analytics.logSignUp(signUpMethod: 'email');
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _getUserFromAuthResult(authResult);
  }

  User _getUserFromAuthResult(AuthResult authResult) {
    return User(
        displayName: authResult.user.displayName,
        email: authResult.user.email,
        id: authResult.user.uid,
        firstName: null,
        lastName: null,
        photoUrl: authResult.user.photoUrl);
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUserId() async {
    return (await _firebaseAuth.currentUser()).uid;
  }
}
