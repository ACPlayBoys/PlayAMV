import 'dart:convert';

class UserAccount {
   bool creator;
   String gender;
   String Fav_sounds;
   String user_videos;
   String profile_pic;
   String version;
   String signup_type;
   String uploads;
   String Liked_Videos;
   int total_fans;
   int total_heart;
   String id;
   String Notifications;
   String device;
   String first_name;
   int total_following;
  UserAccount({
    required this.creator,
    required this.gender,
    required this.Fav_sounds,
    required this.user_videos,
    required this.profile_pic,
    required this.version,
    required this.signup_type,
    required this.uploads,
    required this.Liked_Videos,
    required this.total_fans,
    required this.total_heart,
    required this.id,
    required this.Notifications,
    required this.device,
    required this.first_name,
    required this.total_following,
  });

  UserAccount copyWith({
    bool? creator,
    String? gender,
    String? Fav_sounds,
    String? user_videos,
    String? profile_pic,
    String? version,
    String? signup_type,
    String? uploads,
    String? Liked_Videos,
    int? total_fans,
    int? total_heart,
    String? id,
    String? Notifications,
    String? device,
    String? first_name,
    int? total_following,
  }) {
    return UserAccount(
      creator: creator ?? this.creator,
      gender: gender ?? this.gender,
      Fav_sounds: Fav_sounds ?? this.Fav_sounds,
      user_videos: user_videos ?? this.user_videos,
      profile_pic: profile_pic ?? this.profile_pic,
      version: version ?? this.version,
      signup_type: signup_type ?? this.signup_type,
      uploads: uploads ?? this.uploads,
      Liked_Videos: Liked_Videos ?? this.Liked_Videos,
      total_fans: total_fans ?? this.total_fans,
      total_heart: total_heart ?? this.total_heart,
      id: id ?? this.id,
      Notifications: Notifications ?? this.Notifications,
      device: device ?? this.device,
      first_name: first_name ?? this.first_name,
      total_following: total_following ?? this.total_following,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'creator': creator,
      'gender': gender,
      'Fav_sounds': Fav_sounds,
      'user_videos': user_videos,
      'profile_pic': profile_pic,
      'version': version,
      'signup_type': signup_type,
      'uploads': uploads,
      'Liked_Videos': Liked_Videos,
      'total_fans': total_fans,
      'total_heart': total_heart,
      'id': id,
      'Notifications': Notifications,
      'device': device,
      'first_name': first_name,
      'total_following': total_following,
    };
  }

  factory UserAccount.fromMap(Map<String, dynamic> map) {
    return UserAccount(
      creator: map['creator'] as bool,
      gender: map['gender'] as String,
      Fav_sounds: map['Fav_sounds'] as String,
      user_videos: map['user_videos'] as String,
      profile_pic: map['profile_pic'] as String,
      version: map['version'] as String,
      signup_type: map['signup_type'] as String,
      uploads: map['uploads'] as String,
      Liked_Videos: map['Liked_Videos'] as String,
      total_fans: map['total_fans'].toInt() as int,
      total_heart: map['total_heart'].toInt() as int,
      id: map['id'] as String,
      Notifications: map['Notifications'] as String,
      device: map['device'] as String,
      first_name: map['first_name'] as String,
      total_following: map['total_following'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAccount.fromJson(String source) => UserAccount.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserAccount(creator: $creator, gender: $gender, Fav_sounds: $Fav_sounds, user_videos: $user_videos, profile_pic: $profile_pic, version: $version, signup_type: $signup_type, uploads: $uploads, Liked_Videos: $Liked_Videos, total_fans: $total_fans, total_heart: $total_heart, id: $id, Notifications: $Notifications, device: $device, first_name: $first_name, total_following: $total_following)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserAccount &&
      other.creator == creator &&
      other.gender == gender &&
      other.Fav_sounds == Fav_sounds &&
      other.user_videos == user_videos &&
      other.profile_pic == profile_pic &&
      other.version == version &&
      other.signup_type == signup_type &&
      other.uploads == uploads &&
      other.Liked_Videos == Liked_Videos &&
      other.total_fans == total_fans &&
      other.total_heart == total_heart &&
      other.id == id &&
      other.Notifications == Notifications &&
      other.device == device &&
      other.first_name == first_name &&
      other.total_following == total_following;
  }

  @override
  int get hashCode {
    return creator.hashCode ^
      gender.hashCode ^
      Fav_sounds.hashCode ^
      user_videos.hashCode ^
      profile_pic.hashCode ^
      version.hashCode ^
      signup_type.hashCode ^
      uploads.hashCode ^
      Liked_Videos.hashCode ^
      total_fans.hashCode ^
      total_heart.hashCode ^
      id.hashCode ^
      Notifications.hashCode ^
      device.hashCode ^
      first_name.hashCode ^
      total_following.hashCode;
  }
}