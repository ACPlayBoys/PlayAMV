// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:intl/intl.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/utils/storage.dart';
import 'package:playamv/widgets/profile/content.dart';
import 'package:playamv/widgets/profile/menu.dart';
import "package:velocity_x/velocity_x.dart";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profile_Screen extends StatefulWidget {
  final UserAccount user;
  const Profile_Screen(this.user, {Key? key}) : super(key: key);

  @override
  State<Profile_Screen> createState() => _Profile_ScreenState();
}

class _Profile_ScreenState extends State<Profile_Screen>
    with TickerProviderStateMixin {
  late TabController tabbar;
  bool editable = false;
  var f = NumberFormat.compact(locale: "en_IN");
  List<Widget> widgets = [];
  @override
  void initState() {
    widgets.add(Content(this.widget.user));
    widgets.add(Menu());
    editable = widget.user.id == FirebaseAuth.instance.currentUser!.uid;
    log(editable.toString(), name: "check");
    tabbar = TabController(length: 2, vsync: this); // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //User? user = FirebaseAuth.instance.currentUser;
    var profilePic =
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Container(
        height: 100,
        width: 100,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(widget.user.profile_pic),
            ),
            Visibility(
              visible: editable,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12.5)),
                  child: InkWell(
                    child:
                        Icon(Icons.edit_rounded, color: Colors.black, size: 15),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ]);
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    floating: true,
                    title: "Profile".text.make(),
                  )
                ],
            body: SafeArea(
                bottom: false,
                child: Stack(children: [
                  VxArc(
                    edge: VxEdge.TOP,
                    arcType: VxArcType.CONVEY,
                    height: 50,
                    child: Container(color: Theme.of(context).backgroundColor),
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        profilePic,
                        10.heightBox,
                        widget.user.first_name.text.xl.bold.make(),
                        10.heightBox,
                        !editable
                            ? FollowButton(this.widget.user)
                            : Container(),
                        10.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            "Followers".text.xl2.bold.make(),
                            "Following".text.xl2.bold.make().onInkTap(() {
                              
                            }),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            f.format(6999999).text.xl2.bold.make(),
                            f.format(6999999).text.xl2.bold.make(),
                          ],
                        ),
                        10.heightBox,
                        PageView.builder(
                            itemCount: editable ? 2 : 1,
                            itemBuilder: (BuildContext context, int index) {
                              return IndexedStack(
                                index: index,
                                children: widgets,
                              );
                            }).expand()
                        //Menu(),
                        //Content().expand()
                      ]),
                ]))));
  }
}

class FollowButton extends StatefulWidget {
  final UserAccount user;
  const FollowButton(this.user, {Key? key}) : super(key: key);

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool followed = false;
  var collor = Colors.red;
  @override
  void initState() {
    check();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        followed = !followed;

        Storage.setFollow(
            FirebaseAuth.instance.currentUser!.uid, widget.user.id, followed);
        setState(() {});
      },
      child: followed ? "Follow".text.make() : "Follow".text.make(),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              followed ? Colors.grey : Colors.red)),
    );
  }

  check() async {
    followed = await Storage.isFollowing(
        FirebaseAuth.instance.currentUser!.uid, widget.user.id);
    setState(() {});
  }
}
