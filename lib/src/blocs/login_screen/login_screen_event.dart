import 'package:meta/meta.dart';

@immutable
abstract class LoginScreenEvent {}

class LogIn extends LoginScreenEvent {
  LogIn(this.username, this.password);

  final String password;
  final String username;
}

abstract class SignUp extends LoginScreenEvent {}

class EmailPasswordSignup extends SignUp {
  EmailPasswordSignup(this.username, this.password);

  final String password;
  final String username;
}

class AuthWithGoogle extends SignUp {}
