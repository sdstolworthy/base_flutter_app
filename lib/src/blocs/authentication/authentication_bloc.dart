import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/repositories/user/userRepository.dart';
import './bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => Uninitialized();

  final UserRepository _userRepository;

  AuthenticationBloc(UserRepository userRepository)
      : this._userRepository = userRepository;

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      if (await _userRepository.isSignedIn()) {
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
    _userRepository.signOut();
    yield Unauthenticated();
  }
}
