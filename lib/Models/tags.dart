import 'dart:convert';

import 'package:flutter/foundation.dart';

class Tag {
  final List<String> tags;
  Tag({
    required this.tags,
  });

  Tag copyWith({
    List<String>? tags,
  }) {
    return Tag(
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tags': tags,
    };
  }

  factory Tag.fromMap(Map<dynamic, dynamic> map) {
    return Tag(
      tags: List<String>.from((map['tags'] as List<dynamic>),
    ));
  }

  String toJson() => json.encode(toMap());

  factory Tag.fromJson(String source) => Tag.fromMap(json.decode(source) as Map<dynamic, dynamic>);

  @override
  String toString() => 'Tag(tags: $tags)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Tag &&
      listEquals(other.tags, tags);
  }

  @override
  int get hashCode => tags.hashCode;
}

class liked {
  final List<String> tags;
  liked({
    required this.tags,
  });

  liked copyWith({
    List<String>? tags,
  }) {
    return liked(
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'likedUsers': tags,
    };
  }

  factory liked.fromMap(Map<dynamic, dynamic> map) {
    return liked(
      tags: List<String>.from((map['likedUsers'] as List<dynamic>),
    ));
  }

  String toJson() => json.encode(toMap());

  factory liked.fromJson(String source) => liked.fromMap(json.decode(source) as Map<dynamic, dynamic>);

  @override
  String toString() => 'liked(likedUsers: $tags)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is liked &&
      listEquals(other.tags, tags);
  }

  @override
  int get hashCode => tags.hashCode;
}