import 'package:flutter/material.dart';

@immutable
abstract class LocalizationEvent {}

class ChangeLocalization extends LocalizationEvent {
  final Locale locale;
  ChangeLocalization(this.locale);
}
