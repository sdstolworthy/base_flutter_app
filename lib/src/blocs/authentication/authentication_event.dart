import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class LogIn extends AuthenticationEvent {
  final String username;
  final String password;
  LogIn(this.username, this.password);
}

class LogOut extends AuthenticationEvent {}

class SignUp extends AuthenticationEvent {
  final String username;
  final String password;
  SignUp(this.username, this.password);
}
