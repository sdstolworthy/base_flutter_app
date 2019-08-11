import 'package:faker/faker.dart';
import 'package:flutter/widgets.dart';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String photoUrl;

  get fullName {
    return '$firstName $lastName';
  }

  User(
      {@required this.firstName,
      @required this.lastName,
      @required this.email,
      @required this.photoUrl});

  User.fromJson(Map<String, dynamic> parsedJson)
      : firstName = parsedJson['firstName'],
        lastName = parsedJson['lastName'],
        email = parsedJson['email'],
        photoUrl = parsedJson['photoUrl'];

  User.random() :
    firstName = faker.person.firstName(),
    lastName = faker.person.lastName(),
    email = faker.internet.email(),
    photoUrl = 'https://via.placeholder.com/70';
}
