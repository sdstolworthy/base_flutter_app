import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:flutter_base_app/src/services/navigator.dart';

class WelcomeScreen extends StatelessWidget {
  build(context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(color: theme.primaryColor),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text('Log In',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25)),
                      color: Color.fromRGBO(0, 0, 0, 0.9),
                      highlightColor: Color.fromRGBO(55, 55, 55, 1),
                      onPressed: () {
                        onboardingNavigator
                            .navigateTo(OnboardingRouteNames.loginScreen);
                      },
                    ),
                  )),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text('Sign Up',
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 25)),
                      color: Color.fromRGBO(0, 0, 0, 0.9),
                      highlightColor: Color.fromRGBO(55, 55, 55, 1),
                      onPressed: () {
                        onboardingNavigator
                            .navigateTo(OnboardingRouteNames.signupScreen);
                      },
                    ),
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
