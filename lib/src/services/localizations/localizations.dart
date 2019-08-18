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
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode == null || locale.countryCode.isEmpty
        ? locale.languageCode
        : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static List<AppLocale> availableLocalizations = [
    AppLocale(languageCode: 'en', flag: '🇺🇸'),
    AppLocale(languageCode: 'es', flag: '🇪🇸')
  ];

  static get delegate {
    return AppLocalizationDelegate();
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
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  bool isSupported(Locale locale) {
    return ['en', 'es'].contains(locale.languageCode);
  }

  Future<AppLocalizations> load(Locale locale) {
    return AppLocalizations.load(locale);
  }

  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

class AppLocale {
  final String languageCode;
  final String flag;
  AppLocale({@required languageCode, @required flag})
      : this.languageCode = languageCode,
        this.flag = flag;
}
