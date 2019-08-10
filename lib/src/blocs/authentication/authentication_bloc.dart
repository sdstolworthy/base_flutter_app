import 'dart:async';
import 'package:bloc/bloc.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      // TODO: add logic here to test if logged in
      yield Unauthenticated();
    } else if (event is LogIn) {
      yield* _mapLoginEventToState(event.username, event.password);
    } else if (event is LogOut) {
      yield* _mapLogoutEventToState();
    }
  }

  Stream<AuthenticationState> _mapLoginEventToState(
      String username, String password) async* {}

  Stream<AuthenticationState> _mapLogoutEventToState() async* {}
}
