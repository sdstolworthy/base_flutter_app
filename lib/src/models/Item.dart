import 'package:faker/faker.dart';

class Item {
  String id;
  String title;
  String description;
  String photoUrl;

  Item({this.title, this.description, this.photoUrl});
  Item.fromJson(Map<String, dynamic> parsedJson) {
    title = parsedJson['title'];
    description = parsedJson['description'];
    photoUrl = parsedJson['photoUrl'];
  }

  Item.random()
      : title = faker.lorem.word(),
        description = faker.lorem.sentence(),
        photoUrl = 'https://via.placeholder.com/70';
}
