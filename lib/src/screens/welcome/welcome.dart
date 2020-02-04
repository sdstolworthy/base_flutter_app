import 'package:flutter/material.dart';
import 'package:grateful/src/services/localizations/localizations.dart';
import 'package:grateful/src/services/navigator.dart';
import 'package:grateful/src/services/routes.dart';
import 'package:grateful/src/widgets/background_gradient_provider.dart';
import 'package:grateful/src/widgets/language_picker.dart';
import 'package:grateful/src/widgets/logo_hero.dart';
import 'package:grateful/src/widgets/onboarding_button.dart';

class WelcomeScreen extends StatelessWidget {
  build(context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      body: LayoutBuilder(builder: (_, viewportConstraints) {
        return BackgroundGradientProvider(
            child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    LogoHero(),
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
                                  rootNavigationService.navigateTo(
                                      FlutterAppRoutes.signupScreen);
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
          ),
        ));
      }),
    );
  }
}
