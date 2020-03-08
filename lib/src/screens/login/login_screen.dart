import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/blocs/authentication/bloc.dart';
import 'package:flutter_base_app/src/blocs/login_screen/bloc.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/services/navigator.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/widgets/login_form_field.dart';
import 'package:flutter_base_app/src/widgets/onboarding_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginScreenArguments {
  LoginScreenArguments(this.isLogin);

  final bool isLogin;
}

class LoginScreen extends StatelessWidget {
  LoginScreen(this.isLogin);

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final bool isLogin;
  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final AuthenticationBloc authBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    final ThemeData theme = Theme.of(context);

    final LoginScreenBloc _loginScreenBloc =
        LoginScreenBloc(authenticationBloc: authBloc);
    return BlocProvider<LoginScreenBloc>(
      create: (_) => _loginScreenBloc,
      child: Builder(builder: (BuildContext context) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
            bloc: authBloc,
            condition: (AuthenticationState previousState, AuthenticationState currentState) {
              if ((previousState is Unauthenticated ||
                      previousState is Uninitialized) &&
                  currentState is Authenticated) {
                return true;
              }
              return false;
            },
            listener: (BuildContext context, AuthenticationState state) {
              rootNavigationService
                  .pushReplacementNamed(FlutterAppRoutes.itemFeed);
            },
            child: Scaffold(
                appBar: AppBar(
                    backgroundColor: theme.backgroundColor,
                    elevation: 0,
                    leading: FlatButton(
                      child: Icon(
                        Icons.arrow_back,
                        color: theme.appBarTheme.iconTheme.color,
                      ),
                      onPressed: () => rootNavigationService.goBack(),
                    )),
                body: BlocBuilder<LoginScreenBloc, LoginScreenState>(
                    bloc: _loginScreenBloc,
                    builder: (BuildContext context, LoginScreenState loginState) {
                      return LayoutBuilder(
                          builder: (BuildContext context, BoxConstraints viewportConstraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: viewportConstraints.maxHeight),
                            child: Container(
                              color: theme.backgroundColor,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: IntrinsicHeight(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        isLogin
                                            ? localizations.loginCTA
                                            : localizations.signupCTA,
                                        style: theme.primaryTextTheme.display3,
                                        textAlign: TextAlign.left,
                                      ),
                                      Expanded(child: Container()),
                                      Form(
                                          key: _formKey,
                                          child: _renderLoginForm(context,
                                              isLogin, _loginScreenBloc)),
                                      Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: OnboardingButton(
                                            buttonText: isLogin
                                                ? localizations.logIn
                                                : localizations.signUp,
                                            onPressed: loginState
                                                    is LoginLoading
                                                ? null
                                                : isLogin
                                                    ? () => _handleSignIn(
                                                        _loginScreenBloc)
                                                    : () => _handleRegistration(
                                                        _loginScreenBloc),
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    })));
      }),
    );
  }

  void _handleRegistration(LoginScreenBloc _loginBloc) {
    final String username = emailController.text;
    final String password = passwordController.text;
    if (_formKey.currentState.validate()) {
      _loginBloc.add(EmailPasswordSignup(username, password));
    }
  }

  Widget _renderLoginForm(
      BuildContext context, bool isLogin, LoginScreenBloc loginScreenBloc) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return BlocBuilder<LoginScreenBloc, LoginScreenState>(
        bloc: loginScreenBloc,
        builder: (BuildContext context, LoginScreenState loginScreenState) {
          return Column(mainAxisAlignment: MainAxisAlignment.end, children: <
              Widget>[
            LoginFormField(
              validator: (String input) {
                final bool emailValid = RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(input);
                if (!emailValid) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              enabled: loginScreenState is! LoginLoading,
              icon: Icons.person,
              label: toBeginningOfSentenceCase(localizations.username),
              controller: emailController,
            ),
            LoginFormField(
              icon: Icons.lock,
              label: toBeginningOfSentenceCase(localizations.password),
              isObscured: true,
              controller: passwordController,
              enabled: loginScreenState is! LoginLoading,
              validator: (String input) {
                if (passwordController.text == null ||
                    passwordController.text == '') {
                  return 'Password must not be blank';
                }
                if (!isLogin &&
                    confirmPasswordController.text != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            if (!isLogin)
              LoginFormField(
                controller: confirmPasswordController,
                icon: Icons.lock,
                enabled: loginScreenState is! LoginLoading,
                label: toBeginningOfSentenceCase(localizations.confirmPassword),
                isObscured: true,
                validator: (String input) {
                  if (confirmPasswordController.text !=
                      passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              )
          ]);
        });
  }

  void _handleSignIn(LoginScreenBloc _loginBloc) {
    final String username = emailController.text;
    final String password = passwordController.text;
    if (_formKey.currentState.validate()) {
      _loginBloc.add(LogIn(username, password));
    }
  }
}
