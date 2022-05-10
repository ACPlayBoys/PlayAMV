import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:playamv/Models/comment.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/Models/video.dart';
import 'package:playamv/utils/routes.dart';
import 'package:playamv/utils/storage.dart';
import 'package:video_player/video_player.dart';
import 'package:velocity_x/velocity_x.dart';

class VideoWidget extends StatefulWidget {
  final Video video;
  final UserAccount user;

  const VideoWidget(
    this.video,
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  bool init = false;
  var key1 = GlobalKey();
  bool viewcount = true;
  late VideoPlayerController controller;
  String com = "";

  late String url =
      'https://storage.kanzaki.ru/ANIME___/Golden_Time/%5bJacobSwaggedUp%5d%20Golden%20Time%20-%2001%20%28BD%201280x720%29.mp4';
  @override
  void initState() {
    controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed;
      });

    controller.addListener(() {
      if (!init && controller.value.isInitialized) {
        init = true;
        //controller.play();
        setState(() {});
      }
      if (controller.value.position.inSeconds >
              controller.value.duration.inSeconds / 2 &&
          viewcount) {
        widget.video.views++;
        viewcount = false;
        Storage.updateViews(
            widget.user.id, widget.video.id, widget.video.views);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    log("disposed", name: "check");
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width -
        MediaQuery.of(context).size.width / 3;
    return Material(
      child: Stack(
        children: [
          controller.value.isInitialized
              ? VideoPlayer(controller)
              : Container(
                  child: CircularProgressIndicator().centered(),
                ),
          BackdropFilter(
              filter: ui.ImageFilter.blur(
                sigmaX: 8.0,
                sigmaY: 8.0,
              ),
              child: Container(
                color: Colors.transparent,
              )),
          controller.value.isInitialized
              ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                          height: controller.value.size.height ?? 0,
                          width: controller.value.size.width ?? 0,
                          child: VideoPlayer(controller)))
                  .centered()
              : Container(
                  child: CircularProgressIndicator().centered(),
                ),
          Stack(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(widget.user.profile_pic),
                    ).py12().onInkTap(() {
                      Navigator.of(context)
                          .push(Routes.profileRoute(widget.user));
                    }),
                    Column(
                      children: [
                        widget.video.views.text.xl.make(),
                        "Views".text.make(),
                      ],
                    ).py12(),
                    Hero(
                      tag: key1,
                      child: Image.asset(
                        "assets/images/comment.png",
                        height: 25,
                      ).py12().onInkTap(() {
                        Storage.initComment.value = 0;
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return buildSheet();
                            });
                      }),
                    ),
                    Image.asset(
                      "assets/images/share.png",
                      height: 25,
                    ).py12(),
                    Column(
                      children: [
                        Image.asset(
                          widget.video.isliked
                              ? "assets/images/liked.png"
                              : "assets/images/like.png",
                          height: 25,
                        ).onInkTap(() {
                          if (widget.video.isliked) {
                            widget.video.isliked = false;
                            widget.video.likeCount--;
                          } else {
                            widget.video.isliked = true;
                            widget.video.likeCount++;
                          }
                          Storage.setLike(widget.user.id, widget.video.id,
                              widget.video.isliked);
                          setState(() {});
                        }),
                        widget.video.likeCount.toString().text.make()
                      ],
                    ).py12(),
                  ],
                ).p8().px12(),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.user.first_name.text.xl.make().py4(),
                    SizedBox(
                      width: width,
                      child: widget.video.name.text.maxLines(3).make(),
                    ).py2(),
                    SizedBox(
                      //hastags
                      width: width,
                      child: widget.video.description.text.italic
                          .maxLines(3)
                          .make(),
                    ),
                    Row(
                      children: [
                        Icon(Icons.tag_sharp),
                        widget.video.tags.toString().text.make(),
                      ],
                    ).py4()
                  ],
                ).p8(),
              ),
              ValueListenableBuilder(
                  valueListenable: Storage.refresh,
                  builder: (context, value, widget) {
                    return Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      visible: value.toString().toLowerCase() == 'true',
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: TextButton(
                            onPressed: () {
                              Storage.initHome.value = 0;
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(50),
                              color: Theme.of(context).primaryColorLight,
                              child: "Tap to Refresh"
                                  .text
                                  .color(Theme.of(context).primaryColor)
                                  .make()
                                  .p8(),
                            )).py(50),
                      ),
                    );
                  })
            ],
          ).onInkTap(() {
            log("stacktap", name: "checkq");
            controller.value.isPlaying ? controller.pause() : controller.play();
          })
        ],
      ),
    );
  }

  Widget buildSheet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: key1,
              child: Image.asset(
                "assets/images/comment.png",
                height: 25,
              ),
            ).p(12),
            "Comments".text.make()
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Hero(
              tag: key1,
              child: CircleAvatar(
                backgroundImage: NetworkImage(Storage.currentUser!.profile_pic),
              ),
            ).p(12),
            Expanded(
              child: TextFormField(
                onChanged: ((value) {
                  com = value;
                }),
                decoration: InputDecoration(
                    hintText: "Enter Title", labelText: "Title"),
              ).pOnly(right: 8),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  if (com.isNotBlank && com.isNotEmpty)
                    Storage.putComment(this.widget.video.id, com);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).primaryColorLight,
                  child: "Comment"
                      .text
                      .color(Theme.of(context).primaryColor)
                      .make()
                      .p8(),
                ))
          ],
        ),
        "Comments".text.xl2.make().px12(),
        Divider(
          color: Theme.of(context).primaryColorLight,
          height: 20,
        ).px12(),
        ValueListenableBuilder(
            valueListenable: Storage.initComment,
            builder: (context, value, widget) {
              if (int.parse(value.toString()) == 0) {
                Storage.getComments(this.widget.video.id);
                return CircularProgressIndicator().centered();
              } else {
                return ListView.builder(
                    controller: ScrollController(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: Storage.comments.length,
                    itemBuilder: (context, index) {
                      UserAccount cU = Storage.commentUsers[index];
                      Comment cC = Storage.comments[index];
                      return Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(cU.profile_pic),
                          ),
                          Column(
                            children: [
                              cU.first_name.text.xl.bold
                                  .make()
                                  .pOnly(left: 8, bottom: 2),
                              cC.comment.text.medium.make().pOnly(left: 12)
                            ],
                          )
                        ],
                      ).p(12);
                    });
              }
            }).p(12).expand(),
      ],
    );
  }
}
