import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

abstract class Photograph {}

class NetworkPhoto extends Photograph {
  String title;
  String description;
  String imageUrl;
  NetworkPhoto({
    this.title,
    this.description,
    this.imageUrl,
  });

  NetworkPhoto copyWith({
    String title,
    String description,
    String imageUrl,
  }) {
    return NetworkPhoto(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  static NetworkPhoto fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return NetworkPhoto(
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  static NetworkPhoto fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() =>
      'Photograph title: $title, description: $description, imageUrl: $imageUrl';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is NetworkPhoto &&
        o.title == title &&
        o.description == description &&
        o.imageUrl == imageUrl;
  }

  @override
  int get hashCode => title.hashCode ^ description.hashCode ^ imageUrl.hashCode;
}

class FilePhoto extends Photograph {
  final String guid;
  final File file;
  final String title;
  final String description;
  FilePhoto({String guid, @required this.file, this.title, this.description})
      : guid = guid ?? Uuid().v4();
}
