import 'dart:convert';

import 'package:flutter_base_app/src/models/preferences/user_preference.dart';
import 'package:flutter_base_app/src/theme/theme.dart';

class ColorPreference extends UserPreference {
  ColorPreference({
    String colorIdentifier,
  }) : colorIdentifier =
            colorIdentifier ?? AppColorScheme.blueScheme.identifier;

  final String colorIdentifier;

  @override
  int get hashCode => colorIdentifier.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ColorPreference && other.colorIdentifier == colorIdentifier;
  }

  @override
  String toString() => 'ColorPreference colorIdentifier: $colorIdentifier';

  ColorPreference copyWith({
    String colorIdentifier,
  }) {
    return ColorPreference(
      colorIdentifier: colorIdentifier ?? this.colorIdentifier,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'colorIdentifier': colorIdentifier,
    };
  }

  static ColorPreference fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return ColorPreference(
      colorIdentifier: map['colorIdentifier'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  static ColorPreference fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
