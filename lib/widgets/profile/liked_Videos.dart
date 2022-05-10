// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/Models/video.dart';
import 'package:playamv/utils/routes.dart';
import 'package:playamv/utils/storage.dart';
import 'package:velocity_x/velocity_x.dart';

class LikedVideos extends StatefulWidget {
  final UserAccount user;
  const LikedVideos(this.user, {Key? key}) : super(key: key);

  @override
  State<LikedVideos> createState() => _LikedVideosState();
}

class _LikedVideosState extends State<LikedVideos>{
  @override
  void initState() {
    print(widget.user.first_name);
    Storage.getLikedVideos(widget.user.id);
    //
    // ignore: todo
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ValueListenableBuilder(
      valueListenable: Storage.likedVideos,
      builder: (BuildContext context, List<Video> value, Widget? child) {
        print(value);
        if (value.isNotEmpty && Storage.likedinit) {
          return GridView.builder(
            itemCount: value.length,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Container(
                  child: Image.network(
                    value[index].thumb,
                    fit: BoxFit.fill,
                  ),
                ).p(3),
              ).onInkTap(() async {
                await Navigator.of(context).push(Routes.singleVideoRoute(
                  value[index],
                  widget.user,
                ));
              });
            },
          );
        } else {
          return CircularProgressIndicator().centered();
        }
      },
    ));
  }
}
