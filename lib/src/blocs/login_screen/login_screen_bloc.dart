import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/repositories/user/user_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  @override
  LoginScreenState get initialState => InitialLoginScreenState();

  AuthenticationBloc _authenticationBloc;
  final UserRepository _userRepository;

  FirebaseAnalytics _analytics;

  LoginScreenBloc(
      {UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc,
      FirebaseAnalytics analytics})
      : _authenticationBloc = authenticationBloc,
        this._userRepository = userRepository ?? UserRepository(),
        _analytics = analytics ?? FirebaseAnalytics();

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
        yield LoginLoading();
        await _userRepository.signInWithGoogle();
        _authenticationBloc.add(Authenticate());
        yield InitialLoginScreenState();
      } catch (e, s) {
        print(s);
        print(e);
        print('Error with google auth');
        yield LoginFailure();
      }
    }
  }

  Stream<LoginScreenState> _mapSignUpEventToState(
      String username, String password) async* {
    try {
      yield LoginLoading();
      await _userRepository.signUp(email: username, password: password);
      _authenticationBloc.add(Authenticate());
      _analytics.logSignUp(signUpMethod: 'email');
      yield InitialLoginScreenState();
    } catch (e) {
      yield LoginFailure();
    }
  }

  Stream<LoginScreenState> _mapLoginEventToState(
      String username, String password) async* {
    try {
      yield LoginLoading();
      await _userRepository.signInWithCredentials(username, password);
      _authenticationBloc.add(Authenticate());
      _analytics.logLogin(loginMethod: 'email').catchError((e) {
        print('error logging event to GA');
      });
      yield InitialLoginScreenState();
    } catch (e, s) {
      print(s);
      print("Error during Authentication");
      _authenticationBloc.add(Unauthenticate());
      yield LoginFailure();
    }
  }
}
