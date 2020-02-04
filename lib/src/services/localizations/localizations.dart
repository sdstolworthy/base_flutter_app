import 'package:flutter/material.dart';
import 'package:grateful/l10n/messages_all.dart';
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
    AppLocale(languageCode: 'en', flag: '🇺🇸', title: 'English'),
    AppLocale(languageCode: 'es', flag: '🇪🇸', title: 'Español')
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

  String get email {
    return Intl.message('Email',
        name: 'email', desc: 'The nominative form of email');
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

  String get gratefulPrompt {
    return Intl.message('What are you grateful for today?',
        name: 'gratefulPrompt', desc: 'Prompt for journal input on main page');
  }

  String get addPhotos {
    return Intl.message('Add Photos',
        name: 'addPhotos', desc: 'Add Photos prompt');
  }

  String get previousEntries {
    return Intl.message('Previous Entries',
        name: 'previousEntries', desc: 'Previous Entries title');
  }

  String get journalEntryHint {
    return Intl.message('Write your thoughts...',
        name: 'journalEntryHint', desc: 'Journal entry hint text');
  }

  String get aboutGratefulButtonText {
    return Intl.message('About Grateful',
        name: 'aboutGratefulButtonText',
        desc: 'Button text for links to the About page');
  }

  String get deleteEntryConfirmPrompt {
    return Intl.message('Are you sure you want to delete this entry?',
        name: 'deleteEntryConfirmPrompt',
        desc: 'Warning text when deleting a journal entry');
  }

  String get deleteEntryYes {
    return Intl.message('Yes, delete it',
        name: 'deleteEntryYes',
        desc: 'Action button for the user agreeing to delete an entry');
  }

  String get deleteEntryNo {
    return Intl.message('No, do not delete it',
        name: 'deleteEntryNo',
        desc: 'Action button for the user not wanting to delete a message');
  }

  String get deleteEntryHeader {
    return Intl.message('Delete Journal Entry',
        name: 'deleteEntryHeader', desc: 'Header for delete entry dialog');
  }

  String get shareJournalEntryText {
    return Intl.message('I show my gratitude with Grateful. Download it here:',
        name: 'shareJournalEntryText',
        desc: 'Default share text when a user shares a journal entry');
  }

  String get shareGrateful {
    return Intl.message('Share Grateful',
        name: 'shareGrateful', desc: 'CTA to share grateful');
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
  final String title;
  AppLocale({@required languageCode, @required flag, title})
      : this.languageCode = languageCode,
        this.flag = flag,
        title = title ?? languageCode;
}
