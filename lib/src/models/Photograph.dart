import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';

abstract class Photograph {
  final String guid;
  final dynamic location;
  final String title;
  final String description;
  Photograph({this.guid, this.location, this.title, this.description});

  Map<String, dynamic> toMap() {
    return {
      'guid': guid,
      'location': location,
      'title': title,
      'description': description
    };
  }

  String toJson() => json.encode(toMap());

  @visibleForOverriding
  Photograph copyWith({String guid, String location, String title}) => null;

  @visibleForOverriding
  static Photograph fromMap(Map<String, dynamic> map) => null;

  @override
  String toString() =>
      'Photograph guid: $guid, location: $location, title: $title, description: $description';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Photograph &&
        o.guid == guid &&
        o.location == location &&
        o.title == title &&
        o.description == description;
  }

  @override
  int get hashCode => guid.hashCode ^ location.hashCode ^ title.hashCode;
}

class NetworkPhoto extends Photograph {
  String location;
  NetworkPhoto copyWith({
    String guid,
    String location,
    String title,
    String description,
  }) {
    return NetworkPhoto(
        guid: guid ?? this.guid,
        location: location ?? this.location,
        title: title ?? this.title,
        description: description ?? this.description);
  }

  static NetworkPhoto fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NetworkPhoto(
        guid: map['guid'],
        location: map['location'],
        title: map['title'],
        description: map['description']);
  }

  NetworkPhoto({String guid, String location, String title, String description})
      : super(
            guid: guid,
            location: location,
            title: title,
            description: description);
}

class FilePhoto extends Photograph {
  File location;
  FilePhoto copyWith({
    String guid,
    String location,
    String title,
  }) {
    return FilePhoto(
      guid: guid ?? this.guid,
      location: location ?? this.location,
      title: title ?? this.title,
    );
  }

  static FilePhoto fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return FilePhoto(
        guid: map['guid'],
        location: map['location'],
        title: map['title'],
        description: map['description']);
  }

  FilePhoto({String guid, File location, String title, String description})
      : super(
            guid: guid,
            location: location,
            title: title,
            description: description);
}
