import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';

class User {
  User({
    @required this.firstName,
    @required this.lastName,
    @required this.email,
    this.photoUrl,
    @required this.displayName,
    this.id,
  });

  User.random()
      : firstName = faker.person.firstName(),
        lastName = faker.person.lastName(),
        email = faker.internet.email(),
        id = faker.guid.guid(),
        displayName = faker.person.name(),
        photoUrl = 'https://via.placeholder.com/100';

  final String displayName;
  final String email;
  final String firstName;
  final String id;
  final String lastName;
  final String photoUrl;

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        displayName.hashCode ^
        id.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is User &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.displayName == displayName &&
        other.id == id;
  }

  @override
  String toString() {
    return 'User firstName: $firstName, lastName: $lastName, email: $email, photoUrl: $photoUrl, displayName: $displayName, id: $id';
  }

  String get fullName {
    return displayName ?? '$firstName $lastName';
  }

  String get initials {
    if (firstName != null &&
        lastName != null &&
        firstName.isNotEmpty &&
        lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}';
    } else {
      return 'XX';
    }
  }

  User copyWith({
    String firstName,
    String lastName,
    String email,
    String photoUrl,
    String displayName,
    String id,
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      displayName: displayName ?? this.displayName,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'id': id,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) {
      return null;
    }

    return User(
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      photoUrl: map['photoUrl'] as String,
      displayName: map['displayName'] as String,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  static User fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}
