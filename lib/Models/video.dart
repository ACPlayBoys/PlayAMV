import 'dart:convert';

import 'package:flutter/foundation.dart';

class Video {
  bool isliked = false;
  int likeCount = 0;
  final String comments;
  final String created;
  final String description;
  final String gif;
  final String id;
  final List<String> likedUsers;
  final String name;
  final String sound_id;
  final List<dynamic> tags;
  final String thumb;
  final String url;
  int views;
  Video({
    required this.comments,
    required this.created,
    required this.description,
    required this.gif,
    required this.id,
    required this.likedUsers,
    required this.name,
    required this.sound_id,
    required this.tags,
    required this.thumb,
    required this.url,
    required this.views,
  });

  Video copyWith({
    String? comments,
    String? created,
    String? description,
    String? gif,
    String? id,
    List<String>? likedUsers,
    String? name,
    String? sound_id,
    List<dynamic>? tags,
    String? thumb,
    String? url,
    int? views,
  }) {
    return Video(
      comments: comments ?? this.comments,
      created: created ?? this.created,
      description: description ?? this.description,
      gif: gif ?? this.gif,
      id: id ?? this.id,
      likedUsers: likedUsers ?? this.likedUsers,
      name: name ?? this.name,
      sound_id: sound_id ?? this.sound_id,
      tags: tags ?? this.tags,
      thumb: thumb ?? this.thumb,
      url: url ?? this.url,
      views: views ?? this.views,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comments': comments,
      'created': created,
      'description': description,
      'gif': gif,
      'id': id,
      'likedUsers': likedUsers,
      'name': name,
      'sound_id': sound_id,
      'tags': tags,
      'thumb': thumb,
      'url': url,
      'views': views,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      comments: map['comments'] as String,
      created: map['created'] as String,
      description: map['description'] as String,
      gif: map['gif'] as String,
      id: map['id'] as String,
      likedUsers: List<String>.from((map['likedUsers'] as List<dynamic>)),
      name: map['name'] as String,
      sound_id: map['sound_id'] as String,
      tags: List<dynamic>.from((map['tags'] as List<dynamic>)),
      thumb: map['thumb'] as String,
      url: map['url'] as String,
      views: map['views'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) =>
      Video.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Video(comments: $comments, created: $created, description: $description, gif: $gif, id: $id, likedUsers: $likedUsers, name: $name, sound_id: $sound_id, tags: $tags, thumb: $thumb, url: $url, views: $views)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Video &&
        other.comments == comments &&
        other.created == created &&
        other.description == description &&
        other.gif == gif &&
        other.id == id &&
        listEquals(other.likedUsers, likedUsers) &&
        other.name == name &&
        other.sound_id == sound_id &&
        listEquals(other.tags, tags) &&
        other.thumb == thumb &&
        other.url == url &&
        other.views == views;
  }

  @override
  int get hashCode {
    return comments.hashCode ^
        created.hashCode ^
        description.hashCode ^
        gif.hashCode ^
        id.hashCode ^
        likedUsers.hashCode ^
        name.hashCode ^
        sound_id.hashCode ^
        tags.hashCode ^
        thumb.hashCode ^
        url.hashCode ^
        views.hashCode;
  }
}
