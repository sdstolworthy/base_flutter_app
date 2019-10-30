import 'package:faker/faker.dart';
import 'package:grateful/src/models/Photograph.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  String id;
  String body;
  String description;
  List<Photograph> photographs;

  JournalEntry({this.body, this.description, this.photographs, String id})
      : this.id = id ?? Uuid().v4();
  JournalEntry.fromMap(Map<String, dynamic> parsedJson) {
    body = parsedJson['body'];
    description = parsedJson['description'];
    photographs = parsedJson['photographs'];
  }

  JournalEntry.random()
      : body = faker.lorem.word(),
        description = faker.lorem.sentence();

  toMap() {
    return <String, dynamic>{
      'id': id,
      'body': body,
      'description': description,
      'photographs':
          photographs.map((photograph) => photograph.toMap()).toList(),
    };
  }
}
