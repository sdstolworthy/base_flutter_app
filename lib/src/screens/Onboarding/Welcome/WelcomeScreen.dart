import 'package:flutter/material.dart';
import 'package:spencerstolworthy_goals/src/screens/Onboarding/OnboardingRoutes.dart';
import 'package:spencerstolworthy_goals/src/services/localizations/localizations.dart';
import 'package:spencerstolworthy_goals/src/widgets/LanguagePicker.dart';
import 'package:spencerstolworthy_goals/src/widgets/OnboardingButton.dart';
import 'package:spencerstolworthy_goals/src/widgets/layouts/FullScreenLayout.dart';

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
                            onboardingNavigator
                                .navigateTo(OnboardingRouteNames.loginScreen);
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
                            onboardingNavigator
                                .navigateTo(OnboardingRouteNames.signupScreen);
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
