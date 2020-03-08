import 'package:flutter/material.dart';
import 'package:flutter_base_app/l10n/messages_all.dart';
import 'package:intl/intl.dart';

///
/// Provides internationalization for the app. Consider breaking out into multiple files.
/// @see https://proandroiddev.com/flutter-localization-step-by-step-30f95d06018d
///
/// run `flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/src/services/localizations/localizations.dart`
/// and `flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/src/services/localizations/localizations.dart lib/l10n/intl_*.arb`

class AppLocalizations {
  static List<AppLocale> availableLocalizations = <AppLocale>[
    AppLocale(languageCode: 'en', flag: '🇺🇸', title: 'English'),
    AppLocale(languageCode: 'es', flag: '🇪🇸', title: 'Español')
  ];

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizationDelegate get delegate {
    return const AppLocalizationDelegate();
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get logIn {
    return Intl.message('Log In',
        name: 'logIn', desc: 'The "log in" call to action');
  }

  String get logOut {
    return Intl.message('Log Out',
        name: 'logOut', desc: 'The "log out" call to action');
  }

  String get signUp {
    return Intl.message('Sign Up',
        name: 'signUp', desc: 'The "sign up" call to action');
  }

  String get username {
    return Intl.message('Username',
        name: 'username', desc: 'The nominative form of username');
  }

  String get password {
    return Intl.message('password',
        name: 'password', desc: 'The nominitive form of password');
  }

  String get confirmPassword {
    return Intl.message('confirm password',
        name: 'confirmPassword',
        desc: 'Confirm password text for sign up page');
  }

  String get language {
    return Intl.message('language',
        name: 'language', desc: 'The word \'language\'');
  }

  String get loginCTA {
    return Intl.message('Welcome Back.',
        name: 'loginCTA', desc: 'Call to Action shown on the login page');
  }

  String get signupCTA {
    return Intl.message('Create Account.',
        name: 'signupCTA', desc: 'Call to Action shown on the signup page');
  }

  String get welcomeCTA {
    return Intl.message('Hi, There.',
        name: 'welcomeCTA', desc: 'Call to Action shown on the welcome page');
  }

  String get leaveFeedback {
    return Intl.message('Leave Feedback',
        name: 'leaveFeedback', desc: 'Menu item to leave feedback');
  }

  String get thanksForYourFeedback {
    return Intl.message('Thank you for your feedback!',
        name: 'thanksForYourFeedback',
        desc:
            'Message shown to a user when they leave feedback from the feedback form');
  }

  String get feedbackHint {
    return Intl.message('Let us know what you think',
        name: 'feedbackHint',
        desc: 'Hint text for user in the feedback form textfield');
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return <String>['en', 'es'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

class AppLocale {
  AppLocale({@required this.languageCode, @required this.flag, String title})
      : title = title ?? languageCode;

  final String flag;
  final String languageCode;
  final String title;
}
