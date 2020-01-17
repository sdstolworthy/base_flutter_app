import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_base_app/src/repositories/auth/auth_repository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => Uninitialized();

  final AuthRepository _authRepository;

  Future<String> getCurrentUserId() async {
    return _authRepository.getUserId();
  }

  AuthenticationBloc(AuthRepository userRepository)
      : this._authRepository = userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      if (await _authRepository.isSignedIn()) {
        yield Authenticated();
      } else {
        yield Unauthenticated();
      }
    } else if (event is Authenticate) {
      yield Authenticated();
    } else if (event is Unauthenticate) {
      yield* _mapLogoutEventToState();
    }
  }

  Stream<AuthenticationState> _mapLogoutEventToState() async* {
    _authRepository.signOut();
    yield Unauthenticated();
  }
}
