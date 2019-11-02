import 'package:flutter/material.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/loginScreen/bloc.dart';
import 'package:grateful/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/LoginFormField.dart';
import 'package:grateful/src/widgets/OnboardingButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginScreenArguments {
  final bool isLogin;
  LoginScreenArguments(this.isLogin);
}

class LoginScreen extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final bool isLogin;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  LoginScreen(this.isLogin);
  build(context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final authBloc = BlocProvider.of<AuthenticationBloc>(context);
    final LoginScreenBloc _loginScreenBloc =
        LoginScreenBloc(authenticationBloc: authBloc);

    final theme = Theme.of(context);
    return BlocListener(
      bloc: authBloc,
      condition: (previousState, currentState) {
        if ((previousState is Unauthenticated ||
                previousState is Uninitialized) &&
            currentState is Authenticated) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        rootNavigationService
            .pushReplacementNamed(FlutterAppRoutes.journalPageView);
      },
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              backgroundColor: theme.backgroundColor,
              elevation: 0,
              leading: FlatButton(
                child: Icon(
                  Icons.arrow_back,
                  color: theme.appBarTheme.iconTheme.color,
                ),
                onPressed: () => onboardingNavigator.goBack(),
              )),
          body: BlocBuilder<LoginScreenBloc, LoginScreenState>(
              bloc: _loginScreenBloc,
              builder: (context, loginState) {
                if (loginState is LoginFailure) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                        content: Text(
                            'Something went wrong while' +
                                (isLogin ? ' logging in' : 'signing up'),
                            style: theme.primaryTextTheme.body1)));
                  });
                }
                return Container(
                  color: theme.backgroundColor,
                  child: SafeArea(
                    child:
                        LayoutBuilder(builder: (context, viewportConstraints) {
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
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        ..._renderLoginForm(context, isLogin)
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: OnboardingButton(
                                          buttonText: isLogin
                                              ? localizations.logIn
                                              : localizations.signUp,
                                          onPressed: isLogin
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
                    }),
                  ),
                );
              })),
    );
  }

  _handleRegistration(LoginScreenBloc _loginBloc) {
    final username = usernameController.text;
    final password = passwordController.text;
    _loginBloc.add(SignUp(username, password));
  }

  _renderLoginForm(BuildContext context, bool isLogin) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return [
      LoginFormField(
        icon: Icons.person,
        label: toBeginningOfSentenceCase(localizations.username),
        controller: usernameController,
      ),
      LoginFormField(
        icon: Icons.lock,
        label: toBeginningOfSentenceCase(localizations.password),
        isObscured: true,
        controller: passwordController,
      ),
      if (!isLogin)
        LoginFormField(
          controller: confirmPasswordController,
          icon: Icons.lock,
          label: toBeginningOfSentenceCase(localizations.confirmPassword),
          isObscured: true,
        )
    ];
  }

  _handleSignIn(LoginScreenBloc _loginBloc) {
    final username = usernameController.text;
    final password = passwordController.text;
    _loginBloc.add(LogIn(username, password));
  }
}
