import 'dart:convert';

import 'package:grateful/src/models/Photograph.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  String id;
  String body;
  String description;
  DateTime date;
  List<Photograph> photographs;
  JournalEntry({
    String id,
    this.body,
    this.description,
    DateTime date,
    List<Photograph> photographs,
  })  : this.id = id ?? Uuid().v4(),
        this.date = date ?? DateTime.now(),
        this.photographs = photographs ?? <Photograph>[];

  JournalEntry copyWith({
    String id,
    String body,
    String description,
    DateTime date,
    List<Photograph> photographs,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      body: body ?? this.body,
      description: description ?? this.description,
      date: date ?? this.date,
      photographs: photographs ?? this.photographs,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'body': body,
      'description': description,
      'date': date.millisecondsSinceEpoch,
      'photographs': List<dynamic>.from(photographs.map((x) => x.toMap())),
    };
  }

  static JournalEntry fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return JournalEntry(
      id: map['id'],
      body: map['body'],
      description: map['description'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      photographs: List<Photograph>.from(
          map['photographs']?.map((x) => Photograph.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static JournalEntry fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'JournalEntry id: $id, body: $body, description: $description, date: $date, photographs: $photographs';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is JournalEntry &&
        o.id == id &&
        o.body == body &&
        o.description == description &&
        o.date == date &&
        o.photographs == photographs;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        body.hashCode ^
        description.hashCode ^
        date.hashCode ^
        photographs.hashCode;
  }
}
