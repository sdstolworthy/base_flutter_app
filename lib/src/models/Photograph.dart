import 'dart:convert';

abstract class Photograph {
  final String guid;
  final String location;
  final String title;
  Photograph({
    this.guid,
    this.location,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'guid': guid,
      'location': location,
      'title': title,
    };
  }

  String toJson() => json.encode(toMap());

  Photograph copyWith({String guid, String location, String title}) => null;

  static Photograph fromMap(Map<String, dynamic> map) => null;

  @override
  String toString() =>
      'Photograph guid: $guid, location: $location, title: $title';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is Photograph &&
        o.guid == guid &&
        o.location == location &&
        o.title == title;
  }

  @override
  int get hashCode => guid.hashCode ^ location.hashCode ^ title.hashCode;
}

class NetworkPhoto extends Photograph {
  NetworkPhoto copyWith({
    String guid,
    String location,
    String title,
  }) {
    return NetworkPhoto(
      guid: guid ?? this.guid,
      location: location ?? this.location,
      title: title ?? this.title,
    );
  }

  static NetworkPhoto fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return NetworkPhoto(
      guid: map['guid'],
      location: map['location'],
      title: map['title'],
    );
  }

  NetworkPhoto({String guid, String location, String title})
      : super(guid: guid, location: location, title: title);
}

class FilePhoto extends Photograph {
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
    );
  }

  FilePhoto({String guid, String location, String title})
      : super(guid: guid, location: location, title: title);
}
