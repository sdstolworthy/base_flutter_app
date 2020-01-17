import 'package:meta/meta.dart';

@immutable
abstract class AuthenticationEvent {}

class AppStarted extends AuthenticationEvent {}

class Authenticate extends AuthenticationEvent {
}

class Unauthenticate extends AuthenticationEvent {}
