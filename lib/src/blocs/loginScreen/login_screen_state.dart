import 'package:meta/meta.dart';

@immutable
abstract class LoginScreenState {}

class InitialLoginScreenState extends LoginScreenState {}

class LoginFailure extends LoginScreenState {}

class LoginSuccess extends LoginScreenState {}
