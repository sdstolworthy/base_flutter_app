import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/repositories/user/userRepository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  @override
  LoginScreenState get initialState => InitialLoginScreenState();

  AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepository;

  LoginScreenBloc(
      {UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc})
      : _authenticationBloc = authenticationBloc,
        this._userRepository = userRepository ?? UserRepository();

  @override
  Stream<LoginScreenState> mapEventToState(
    LoginScreenEvent event,
  ) async* {
    if (event is LogIn) {
      yield* _mapLoginEventToState(event.username, event.password);
    } else if (event is SignUp) {
      yield* _mapSignUpEventToState(event.username, event.password);
    } else if (event is AuthWithGoogle) {
      try {
        await _userRepository.signInWithGoogle();
        _authenticationBloc.add(Authenticate());
      } catch (e) {
        print(e);
        print('Error with google auth');
        yield LoginFailure();
      }
    }
  }

  Stream<LoginScreenState> _mapSignUpEventToState(
      String username, String password) async* {
    try {
      await _userRepository.signUp(email: username, password: password);
      _authenticationBloc.add(Authenticate());
    } catch (e) {
      yield LoginFailure();
    }
  }

  Stream<LoginScreenState> _mapLoginEventToState(
      String username, String password) async* {
    try {
      await _userRepository.signInWithCredentials(username, password);
      _authenticationBloc.add(Authenticate());
    } catch (e, s) {
      print(e);
      print(s);
      print("Error during Authentication");
      _authenticationBloc.add(Unauthenticate());
      yield LoginFailure();
    }
  }
}
