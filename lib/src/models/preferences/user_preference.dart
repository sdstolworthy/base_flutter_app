import 'dart:convert';

import 'package:flutter_base_app/src/models/preferences/color_preference.dart';
import 'package:flutter_base_app/src/models/preferences/language_settings.dart';

class UserPreferenceSettings {
  UserPreferenceSettings({this.userLanguageSettings, this.colorPreference});

  UserLanguageSettings userLanguageSettings;
  ColorPreference colorPreference;

  @override
  int get hashCode => userLanguageSettings.hashCode ^ colorPreference.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserPreferenceSettings &&
        other.userLanguageSettings == userLanguageSettings &&
        other.colorPreference == colorPreference;
  }

  @override
  String toString() =>
      'UserPreferenceSettings userLanguageSettings: $userLanguageSettings, colorPreference: $colorPreference';

  UserPreferenceSettings copyWith(
      {UserLanguageSettings userLanguageSettings,
      ColorPreference colorPreference}) {
    return UserPreferenceSettings(
        userLanguageSettings: userLanguageSettings ?? this.userLanguageSettings,
        colorPreference: colorPreference ?? this.colorPreference);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userLanguageSettings': userLanguageSettings?.toMap(),
      'colorPreference': colorPreference?.toMap(),
    };
  }

  static UserPreferenceSettings fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return UserPreferenceSettings(
        userLanguageSettings: map['userLanguageSettings'] != null
            ? UserLanguageSettings.fromMap(Map<String, dynamic>.from(
                map['userLanguageSettings'] as Map<String, dynamic>))
            : null,
        colorPreference: map['colorPreference'] != null
            ? ColorPreference.fromMap(
                Map<String, dynamic>.from(
                    map['colorPreference'] as Map<String, dynamic>),
              )
            : null);
  }

  String toJson() => json.encode(toMap());

  static UserPreferenceSettings fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

abstract class UserPreference {
  Map<String, dynamic> toMap();
}
