import 'dart:convert';

import 'package:flutter_base_app/src/models/preferences/user_preference.dart';

class UserLanguageSettings extends UserPreference {
  UserLanguageSettings({
    this.locale,
  });

  final String locale;

  @override
  int get hashCode => locale.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserLanguageSettings && other.locale == locale;
  }

  @override
  String toString() => 'UserLanguageSettings locale: $locale';

  UserLanguageSettings copyWith({
    String locale,
  }) {
    return UserLanguageSettings(
      locale: locale ?? this.locale,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'locale': locale,
    };
  }

  static UserLanguageSettings fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return UserLanguageSettings(
      locale: map['locale'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  static UserLanguageSettings fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
