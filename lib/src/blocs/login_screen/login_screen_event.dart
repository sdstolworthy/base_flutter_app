import 'package:meta/meta.dart';

@immutable
abstract class LoginScreenEvent {}

class LogIn extends LoginScreenEvent {
  final String username;
  final String password;
  LogIn(this.username, this.password);
}

abstract class SignUp extends LoginScreenEvent {}

class EmailPasswordSignup extends SignUp {
  final String username;
  final String password;
  EmailPasswordSignup(this.username, this.password);
}

class AuthWithGoogle extends SignUp {}
