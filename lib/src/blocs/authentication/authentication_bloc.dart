import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:spencerstolworthy_goals/src/repositories/user/userRepository.dart';
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
    } else if (event is LogIn) {
      yield* _mapLoginEventToState(event.username, event.password);
    } else if (event is LogOut) {
      yield* _mapLogoutEventToState();
    } else if (event is SignUp) {
      yield* _mapSignUpEventToState(event.username, event.password);
    }
  }

  Stream<AuthenticationState> _mapSignUpEventToState(
      String username, String password) async* {
    await _userRepository.signUp(email: username, password: password);
    yield Authenticated();
  }

  Stream<AuthenticationState> _mapLoginEventToState(
      String username, String password) async* {
    try {
      final user =
          await _userRepository.signInWithCredentials(username, password);
      yield Authenticated();
    } catch (e, s) {
      print(s);
      print(e);
      print("Error during Authentication");
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLogoutEventToState() async* {
    _userRepository.signOut();
    yield Unauthenticated();
  }
}
