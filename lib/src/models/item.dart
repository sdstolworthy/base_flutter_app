import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

class Item {
  Item({this.title, this.description, this.photoUrl, String id})
      : id = id ?? Uuid().v4();

  Item.fromMap(Map<String, dynamic> parsedJson) {
    title = parsedJson['title'] as String;
    description = parsedJson['description'] as String;
    photoUrl = parsedJson['photoUrl'] as String;
  }

  Item.random()
      : title = faker.lorem.word(),
        description = faker.lorem.sentence(),
        photoUrl = 'https://via.placeholder.com/70';

  String description;
  String id;
  String photoUrl;
  String title;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'photoUrl': photoUrl
    };
  }
}
