import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:grateful/src/blocs/authentication/bloc.dart';
import 'package:grateful/src/blocs/loginScreen/bloc.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/BackgroundGradientProvider.dart';
import 'package:grateful/src/widgets/LoginFormField.dart';
import 'package:grateful/src/widgets/LogoHero.dart';
import 'package:grateful/src/widgets/OnboardingButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class LoginScreenArguments {
  final bool isLogin;
  LoginScreenArguments(this.isLogin);
}

class LoginScreen extends StatefulWidget {
  final bool isLogin;
  LoginScreen(this.isLogin);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreen(this.isLogin);
  }
}

class _LoginScreen extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool isLogin;
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  _LoginScreen(this.isLogin);
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
                onPressed: () => rootNavigationService.goBack(),
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
                return BackgroundGradientProvider(
                  child: Container(
                    child: SafeArea(
                      child: LayoutBuilder(
                          builder: (context, viewportConstraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: viewportConstraints.maxHeight),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: IntrinsicHeight(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Row(children: [
                                        Container(
                                            constraints: BoxConstraints(
                                                maxHeight: 100, maxWidth: 100),
                                            child: LogoHero()),
                                        Flexible(
                                          child: Text(
                                            isLogin
                                                ? localizations.loginCTA
                                                : localizations.signupCTA,
                                            style:
                                                theme.primaryTextTheme.display1,
                                          ),
                                        )
                                      ]),
                                      Expanded(child: Container()),
                                      Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              ..._renderLoginForm(
                                                  context, isLogin)
                                            ],
                                          )),
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
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                height: 50,
                                                child: GoogleSignInButton(
                                                  darkMode: true,
                                                  onPressed: () {
                                                    _loginScreenBloc
                                                        .add(AuthWithGoogle());
                                                  },
                                                ),
                                              ),
                                            )
                                            // Expanded(
                                            //   child: GoogleSignInButton(
                                            //     onPressed: () => _loginScreenBloc
                                            //         .add(AuthWithGoogle()),
                                            //   ),
                                            // )
                                          ],
                                        ),
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
                  ),
                );
              })),
    );
  }

  _handleRegistration(LoginScreenBloc _loginBloc) {
    final username = emailController.text;
    final password = passwordController.text;
    if (_formKey.currentState.validate()) {
      _loginBloc.add(SignUp(username, password));
    }
  }

  _renderLoginForm(BuildContext context, bool isLogin) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return [
      LoginFormField( 
        validator: (input) {
          final bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
              .hasMatch(input);
          if (!emailValid) {
            return 'Please enter a valid email address';
          }
          return null;
        },
        icon: Icons.person,
        label: toBeginningOfSentenceCase(localizations.email),
        controller: emailController,
      ),
      LoginFormField(
        icon: Icons.lock,
        label: toBeginningOfSentenceCase(localizations.password),
        isObscured: true,
        controller: passwordController,
        validator: (input) {
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
          label: toBeginningOfSentenceCase(localizations.confirmPassword),
          isObscured: true,
          validator: (input) {
            if (confirmPasswordController.text != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        )
    ];
  }

  _handleSignIn(LoginScreenBloc _loginBloc) {
    final username = emailController.text;
    final password = passwordController.text;
    if (_formKey.currentState.validate()) {
      _loginBloc.add(LogIn(username, password));
    }
  }
}
