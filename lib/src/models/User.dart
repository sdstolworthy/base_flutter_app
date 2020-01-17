import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;
  final String displayName;
  final String id;
  get fullName {
    return displayName ?? '$firstName $lastName';
  }

  get initials {
    if (this.firstName != null &&
        this.lastName != null &&
        this.firstName.length > 0 &&
        this.lastName.length > 0) {
      return '${this.firstName[0]}${this.lastName[0]}';
    } else
      return 'XX';
  }

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

  @override
  String toString() {
    return 'User firstName: $firstName, lastName: $lastName, email: $email, photoUrl: $photoUrl, displayName: $displayName, id: $id';
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
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'photoUrl': photoUrl,
      'displayName': displayName,
      'id': id,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      photoUrl: map['photoUrl'],
      displayName: map['displayName'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  static User fromJson(String source) => fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is User &&
        o.firstName == firstName &&
        o.lastName == lastName &&
        o.email == email &&
        o.photoUrl == photoUrl &&
        o.displayName == displayName &&
        o.id == id;
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        email.hashCode ^
        photoUrl.hashCode ^
        displayName.hashCode ^
        id.hashCode;
  }
}
