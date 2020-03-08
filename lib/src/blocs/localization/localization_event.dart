import 'package:flutter/material.dart';

@immutable
abstract class LocalizationEvent {}

class ChangeLocalization extends LocalizationEvent {
  ChangeLocalization(this.locale);

  final Locale locale;
}
