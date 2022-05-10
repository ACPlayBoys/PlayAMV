import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:playamv/Models/comment.dart';
import 'package:playamv/Models/tags.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/Models/video.dart';
import 'package:playamv/widgets/profile/get_videos.dart';

class Storage {
  static UserAccount? currentUser;

  static final x = ValueNotifier<double>(0.0);

  static Future<bool> isUserRegistered(DatabaseReference ref) async {
    var dataSnapshot = (await ref.once());
    bool val = (dataSnapshot.snapshot.exists);
    return val;
  }

  static setUser(User? user) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("user");
    bool val = await isUserRegistered(
        ref.child(FirebaseAuth.instance.currentUser!.uid));
    user!;

    if (!val) {
      var name = user.displayName;
      var gender = "male";
      var id = FirebaseAuth.instance.currentUser!.uid;
      var profilePic = user.photoURL;
      var signup_type = "google";
      bool? creator = true;
      int? total_fans = 0;
      int? total_following = 0;
      int? total_heart = 0;
      var uploads = "ref";
      int? user_videos = 0;
      String version = "1.0";
      var device = "emulator";
      var Fav_sounds = "ref";
      var Liked_Videos = "erf";
      var Notifications = "ref";
      var user_video = "ref";
      UserAccount newUser = UserAccount(
          Fav_sounds: Fav_sounds,
          Liked_Videos: Liked_Videos,
          Notifications: Notifications,
          device: device,
          first_name: name.toString(),
          gender: gender,
          id: id.toString(),
          profile_pic: profilePic.toString(),
          signup_type: signup_type,
          creator: creator,
          total_fans: total_fans,
          total_following: total_following,
          total_heart: total_heart,
          uploads: uploads,
          user_videos: user_video,
          version: version);
      ref.child(user.uid).set(newUser.toMap());
      currentUser = newUser;
    } else {
      var dataSnapshot = (await ref.child(user.uid).once());
      Map<dynamic, dynamic> u =
          dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
      currentUser = await UserAccount.fromJson(json.encode(u));

      log(currentUser!.uploads.toString(), name: "check");
    }
  }

  static Future<void> update(File? file, BuildContext context) async {
    final _firebaseStorage = FirebaseStorage.instance.ref();
    //thumb
    showToast(context, "uploading thumbnail");
    final snapshot1 = _firebaseStorage.child('images/temp').putFile(file!);
    snapshot1.snapshotEvents.listen((TaskSnapshot snapshot) {
      x.value =
          snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
    });
    var thumbUrl;
    snapshot1.whenComplete(
        () async => thumbUrl = await snapshot1.snapshot.ref.getDownloadURL());

    print(thumbUrl);
  }

  static Future<void> upload(File? file, String fileName, List<String> tags,
      String title, String desc, BuildContext context) async {
    if (currentUser!.uploads.toString() == "ref") {
      DatabaseReference ref = FirebaseDatabase.instance.ref("uploads");
      currentUser!.uploads = FirebaseAuth.instance.currentUser!.uid.toString();
      ref = FirebaseDatabase.instance.ref("user");
      ref
          .child(FirebaseAuth.instance.currentUser!.uid.toString())
          .set(currentUser!.toMap());
    }
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("uploads").child(currentUser!.uploads);

    String name = ref.push().key!;
    final _firebaseStorage = FirebaseStorage.instance.ref();
    //thumb
    showToast(context, "uploading thumbnail");
    final snapshot1 =
        _firebaseStorage.child('images/$name').putFile(File(fileName));
    snapshot1.snapshotEvents.listen((TaskSnapshot snapshot) {
      x.value =
          snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
    });
    snapshot1.whenComplete((() async {
      var thumbUrl = await snapshot1.snapshot.ref.getDownloadURL();
      showToast(context, "uploading Video");
      //video
      final snapshot2 = _firebaseStorage.child('video/$name').putFile(file!);
      snapshot2.snapshotEvents.listen((TaskSnapshot snap) {
        x.value = snap.bytesTransferred.toDouble() / snap.totalBytes.toDouble();
      });
      snapshot2.whenComplete(() async {
        var downloadUrl = await snapshot2.snapshot.ref.getDownloadURL();
        print(downloadUrl);
        print(thumbUrl);
        Video upload = Video(
            id: name,
            name: title,
            comments: "comments",
            created: "created",
            description: desc,
            gif: "gif",
            likedUsers: ["tamago"],
            sound_id: "sound_id",
            thumb: thumbUrl,
            url: downloadUrl,
            views: 0,
            tags: tags);
        ref.child(name).set(upload.toMap());
        ref = FirebaseDatabase.instance.ref("hashtags");
        for (String item in tags) {
          ref.child(item).child(name).set(true);
        }
        FirebaseDatabase.instance
            .ref("content")
            .child(name)
            .set(FirebaseAuth.instance.currentUser!.uid);
      });
    }));
  }

  static void showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg.toString()),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static List homeVideos = [];
  static List users = [];
  static final initHome = ValueNotifier<int>(0);
  static getVideosHome(bool first) async {
    if (first) {
      refresh.value = false;
      DatabaseReference ref = FirebaseDatabase.instance.ref("content");
      ref.limitToLast(5).onValue.listen((event) {
        for (final child in event.snapshot.children) {
          refresh.value = false;
          log(child.key.toString(), name: "checkqt");
          homeVideos.insert(0, child.key.toString());
          users.insert(0, child.value.toString());
          // Handle the post.
        }
        initHome.value = homeVideos.length;
      }, onError: (error) {
        // Error.
      });
    } else {
      DatabaseReference refr = FirebaseDatabase.instance.ref("content");
      //log(homeVideos.last, name: "checkqt");
      refr
          .orderByKey()
          .endBefore(homeVideos.last)
          .limitToLast(5)
          .onValue
          .listen((event) {
        bool insert = true;
        for (final child in event.snapshot.children) {
          if (insert) {
            insert = false;

            homeVideos.add(child.key.toString());
            users.add(child.value.toString());
          } else {
            homeVideos.insert(homeVideos.length - 1, child.key.toString());
            users.insert(homeVideos.length - 1, child.value.toString());
          }
        }
        homeVideos.forEach((element) {
          log(element.toString(), name: "checkqt");
        });

        initHome.value = homeVideos.length;
      }, onError: (error) {
        // Error.
      });
    }
  }

  static final currentVideo = ValueNotifier<Video?>(null);
  static UserAccount? dispalyuser = null;
  static getVideobyId(String uid, String vid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("user").child(uid);
    var dataSnapshot = await ref.once();
    dispalyuser =
        UserAccount.fromJson(json.encode(dataSnapshot.snapshot.value));

    ref = FirebaseDatabase.instance.ref("uploads").child(uid).child(vid);
    dataSnapshot = await ref.once();
    currentVideo.value =
        Video.fromJson(json.encode(dataSnapshot.snapshot.value));
    isLikedByCurrentUser(uid, vid, currentVideo.value!.likedUsers);
  }

  static updateViews(String uid, String vid, int views) {
    FirebaseDatabase.instance
        .ref("uploads")
        .child(uid)
        .child(vid)
        .child("views")
        .set(views);
  }

  static final initComment = ValueNotifier<int>(0);
  static List<Comment> comments = [];
  static List<UserAccount> commentUsers = [];
  static getComments(String vid) async {
    comments = [];
    commentUsers = [];
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("comments").child(vid);
    var dataSnapshot = await ref.once();
    for (final child in dataSnapshot.snapshot.children) {
      Comment cm = Comment.fromJson(json.encode(child.value));
      ref = FirebaseDatabase.instance.ref("user").child(cm.uid);
      var dataSnapshot = await ref.once();
      commentUsers
          .add(UserAccount.fromJson(json.encode(dataSnapshot.snapshot.value)));
      comments.add(cm);
    }
    initComment.value = 1;
  }

  static putComment(String vid, String com) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("comments").child(vid);
    String cId = ref.push().key.toString();
    Comment newComment = Comment(
        comment: com,
        id: cId,
        uid: FirebaseAuth.instance.currentUser!.uid,
        date: DateTime.now().toIso8601String());
    ref.child(cId).set(newComment.toMap());
  }

  static setLike(String uid, String vid, bool swit) async {
    var ref = FirebaseDatabase.instance.ref("uploads").child(uid).child(vid);
    var ref2 = FirebaseDatabase.instance
        .ref("likedVideos")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(vid);
    var dataSnapshot = (await ref.once());
    Map<dynamic, dynamic> u =
        dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
    List<String> list = liked.fromJson(json.encode(u).toString()).tags;
    if (swit) {
      list.add(FirebaseAuth.instance.currentUser!.uid);
      ref2.set(uid);
    } else {
      ref2.set(null);
      list.remove(FirebaseAuth.instance.currentUser!.uid);
    }
    ref.child("likedUsers").set(list);
  }

  static Future<void> isLikedByCurrentUser(String uid, String vid, tags) async {
    log("chal rha hai", name: "check");
    List<String> list = tags;
    log(currentVideo.value.toString(), name: "checkqt");
    currentVideo.value!.likeCount = list.length - 1;
    if (list.contains(FirebaseAuth.instance.currentUser!.uid)) {
      log("liked hai bro", name: "check");
      currentVideo.value!.isliked = true;
    }
  }

  static final refresh = ValueNotifier<bool>(false);
  static doinmg() {
    var ref =
        FirebaseDatabase.instance.ref("content").onChildAdded.listen((event) {
      refresh.value = true;
    });
    ;
  }

  static final myVideos = ValueNotifier<List<Video>>([]);
  static bool myinit = false;
  static getVideos(String child) async {
    myinit = false;
    List<Video> temp = [];
    var ref = FirebaseDatabase.instance.ref("uploads").child(child);
    var dataSnapshot = (await ref.once());
    Map<dynamic, dynamic> u =
        dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
    u.forEach((key, value) {
      var v = Video.fromJson(json.encode(value).toString());
      temp.add(v);
    });
    myinit = true;
    myVideos.value = temp;
  }

  static final likedVideos = ValueNotifier<List<Video>>([]);
  static bool likedinit = false;
  static getLikedVideos(String child) async {
    likedinit = false;
    List<Video> temp = [];
    var ref = FirebaseDatabase.instance.ref("likedVideos").child(child);
    var dataSnapshot = (await ref.once());

    Map<dynamic, dynamic> u =
        dataSnapshot.snapshot.value as Map<dynamic, dynamic>;
    try {
      try {
        for (var child in u.entries) {
          log(child.key, name: "checkqt");
          log(child.value, name: "checkqt");
          var ref = FirebaseDatabase.instance
              .ref("uploads")
              .child(child.value)
              .child(child.key);
          var dataSnapshot1 = (await ref.once());
          Map<dynamic, dynamic> u1 =
              dataSnapshot1.snapshot.value as Map<dynamic, dynamic>;

          log(dataSnapshot1.snapshot.value.toString(), name: "checkqt");
          Video.fromJson(json.encode(dataSnapshot1.snapshot.value));
          temp.add(Video.fromJson(json.encode(dataSnapshot1.snapshot.value)));
        }
        likedinit = true;
        likedVideos.value = temp;
      } on Exception catch (e) {
        // TODO
      }
    } on Error catch (e) {
      // TODO
    }
  }

  static setFollow(String uid, String followId, bool swit) async {
    var ref =
        FirebaseDatabase.instance.ref("Following").child(uid).child(followId);
    var ref2 =
        FirebaseDatabase.instance.ref("Followers").child(followId).child(uid);
    var dataSnapshot = (await ref.once());

    if (swit) {
      ref.set(uid);
      ref2.set(followId);
    } else {
      ref.set(null);
    }
  }

  static isFollowing(String uid, String followId) async {
    var ref =
        FirebaseDatabase.instance.ref("Following").child(uid).child(followId);
    var dataSnapshot = (await ref.once());
    bool val = (dataSnapshot.snapshot.exists);
    return val;
  }

  static getFollowingCount(String uid) async {
    var ref = FirebaseDatabase.instance.ref("Following").child(uid);
    var dataSnapshot = (await ref.once());
    bool val = (dataSnapshot.snapshot.exists);
    if (val)
      return (dataSnapshot.snapshot.children.length);
    else
      return (0);
  }
}
