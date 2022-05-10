import 'dart:convert';

class Comment {
  final String comment;
  final String id;
  final String uid;
  final String date;
  Comment({
    required this.comment,
    required this.id,
    required this.uid,
    required this.date,
  });

  Comment copyWith({
    String? comment,
    String? id,
    String? uid,
    String? date,
  }) {
    return Comment(
      comment: comment ?? this.comment,
      id: id ?? this.id,
      uid: uid ?? this.uid,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment': comment,
      'id': id,
      'uid': uid,
      'date': date,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      comment: map['comment'] as String,
      id: map['id'] as String,
      uid: map['uid'] as String,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) => Comment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Comment(comment: $comment, id: $id, uid: $uid, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Comment &&
      other.comment == comment &&
      other.id == id &&
      other.uid == uid &&
      other.date == date;
  }

  @override
  int get hashCode {
    return comment.hashCode ^
      id.hashCode ^
      uid.hashCode ^
      date.hashCode;
  }
}