import 'package:flutter/material.dart';
import 'package:flutter_base_app/src/services/localizations/localizations.dart';
import 'package:flutter_base_app/src/widgets/LanguagePicker.dart';
import 'package:flutter_base_app/src/widgets/OnboardingButton.dart';
import 'package:flutter_base_app/src/widgets/layouts/FullScreenLayout.dart';
import 'package:flutter_base_app/src/services/routes.dart';
import 'package:flutter_base_app/src/services/navigator.dart';

class WelcomeScreen extends StatelessWidget {
  build(context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    final theme = Theme.of(context);
    return Scaffold(
      body: FullScreenLayout(
        backgroundColor: theme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              Text(
                localizations.welcomeCTA,
                style: theme.primaryTextTheme.display3,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: OnboardingButton(
                          buttonText: localizations.logIn,
                          onPressed: () {
                            rootNavigationService
                                .navigateTo(FlutterAppRoutes.loginScreen);
                          },
                        )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: OnboardingButton(
                          buttonText: localizations.signUp,
                          isInverted: true,
                          onPressed: () {
                            rootNavigationService
                                .navigateTo(FlutterAppRoutes.signupScreen);
                          },
                        )),
                      ],
                    )
                  ],
                ),
              ),
              LanguagePicker()
            ],
          ),
        ),
      ),
    );
  }
}
