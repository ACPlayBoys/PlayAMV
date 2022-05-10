import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:playamv/Models/video.dart';
import 'package:playamv/utils/storage.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/widgets/video_widget.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  bool inint = false;
  @override
  void initState() {
    // fetcher(true);
    // TODO: implement initState
    super.initState();
    Storage.doinmg();
  }

  Future<void> fetcher(bool first) async {
    await Storage.getVideosHome(first);
    inint = true;
  }

  @override
  Widget build(BuildContext context) {
    log("yes i am rebuilding".toString(), name: "checkq");
    return ValueListenableBuilder(
        valueListenable: Storage.initHome,
        builder: (context, value, widget) {
          log("calling", name: "checkqt");
          //TODO here you can setState or whatever you need
          if (int.parse(value.toString()) > 0) {
            return Container(
                child: PageView.builder(
                    scrollDirection: Axis.vertical,
                    onPageChanged: (index) async {
                      Storage.initComment.value = 0;
                      //Storage.currentVideo.value = null;
                      if (index == Storage.homeVideos.length - 2)
                        fetcher(false);
                    },
                    itemCount: Storage.homeVideos.length,
                    itemBuilder: (BuildContext context, int index) {
                      Storage.getVideobyId(
                          Storage.users[index], Storage.homeVideos[index]);
                      return ValueListenableBuilder(
                          valueListenable: Storage.currentVideo,
                          builder: (context, value, widget) {
                            Video cV = value as Video;
                            if (value != null) {
                              return VideoWidget(cV, Storage.dispalyuser!);
                            } else
                              return Container(
                                  child:
                                      CircularProgressIndicator().centered());
                          });
                    }));
          } else {
            fetcher(true);
            return Container(child: CircularProgressIndicator().centered());
          }
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
