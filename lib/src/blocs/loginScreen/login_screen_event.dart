import 'package:meta/meta.dart';

@immutable
abstract class LoginScreenEvent {}

class LogIn extends LoginScreenEvent {
  final String username;
  final String password;
  LogIn(this.username, this.password);
}

class SignUp extends LoginScreenEvent {
  final String username;
  final String password;
  SignUp(this.username, this.password);
}
