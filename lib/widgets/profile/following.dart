import 'package:flutter/material.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/utils/storage.dart';

class Following extends StatefulWidget {
  final UserAccount user;
  const Following(this.user, {Key? key}) : super(key: key);

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  @override
  void initState() {
    fetchFollowing();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material();
  }

  void fetchFollowing() {
    int count=Storage.getFollowingCount(widget.user.id);
  }
}
