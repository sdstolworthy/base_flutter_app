import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/models/user.dart';
import 'package:flutter_base_app/src/repositories/auth/auth_repository.dart';
import 'package:flutter_base_app/src/repositories/user/user_repository.dart';
import 'package:meta/meta.dart';
import './bloc.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  LoginScreenBloc(
      {AuthRepository authRepository,
      UserRepository userRepository,
      @required AuthenticationBloc authenticationBloc,
      FirebaseAnalytics analytics})
      : _authenticationBloc = authenticationBloc,
        userRepository = userRepository ?? UserRepository(),
        _authRepository = authRepository ?? AuthRepository(),
        _analytics = analytics ?? FirebaseAnalytics();

  final UserRepository userRepository;

  final FirebaseAnalytics _analytics;
  final AuthenticationBloc _authenticationBloc;
  final AuthRepository _authRepository;

  @override
  LoginScreenState get initialState => InitialLoginScreenState();

  @override
  Stream<LoginScreenState> mapEventToState(
    LoginScreenEvent event,
  ) async* {
    if (event is LogIn) {
      yield* _mapLoginEventToState(event.username, event.password);
    } else if (event is SignUp) {
      yield* _mapSignUpEventToState(event);
    } else if (event is AuthWithGoogle) {
      try {
        yield LoginLoading();
        await _authRepository.signInWithGoogle();
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

  Stream<LoginScreenState> _mapSignUpEventToState(SignUp event) async* {
    try {
      yield LoginLoading();
      if (event is EmailPasswordSignup) {
        final User user = await _authRepository.signUp(
            email: event.username, password: event.password);
        _authenticationBloc.add(Authenticate());
        _analytics.logSignUp(signUpMethod: 'email');
        print(user.toString());
      }
      yield InitialLoginScreenState();
    } catch (e) {
      yield LoginFailure();
    }
  }

  Stream<LoginScreenState> _mapLoginEventToState(
      String username, String password) async* {
    try {
      yield LoginLoading();
      await _authRepository.signInWithCredentials(username, password);
      _authenticationBloc.add(Authenticate());
      _analytics.logLogin(loginMethod: 'email').catchError((Error e) {
        print('error logging event to GA');
      });
      yield InitialLoginScreenState();
    } catch (e, s) {
      print(s);
      print('Error during Authentication');
      _authenticationBloc.add(Unauthenticate());
      yield LoginFailure();
    }
  }
}
