// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:playamv/screens/create_screen.dart';
import 'package:playamv/screens/profile_screen.dart';
import 'package:playamv/screens/video_screen.dart';
import 'package:playamv/utils/storage.dart';
import 'package:playamv/widgets/video_widget.dart';
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int currentIndex = 0;
  List<Widget> widgets = [
    VideoScreen(),
    Container(),
    CreateScreen().py12().px8(),
    Container(),
    Profile_Screen(Storage.currentUser!)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: widgets,
        ),
        bottomNavigationBar: BottomNavigationBar(
            iconSize: 20.0,
            currentIndex: currentIndex,
            onTap: (value) {
              if (value == 4) {
                // Storage.myVideos.value = [];
                // Storage.likedVideos.value = [];
                // Storage.getVideos(Storage.currentUser!.id);
                // Storage.getLikedVideos(Storage.currentUser!.id);
              }
              setState(() {
                currentIndex = value;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                label: "home",
                icon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: "discover",
                icon: Image.asset(
                  "assets/images/discover.png",
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: "create",
                icon: Image.asset(
                  "assets/images/create.png",
                  height: 25,
                ),
              ),
              BottomNavigationBarItem(
                label: "notifications",
                icon: Image.asset(
                  "assets/images/notif.png",
                  height: 20,
                ),
              ),
              BottomNavigationBarItem(
                label: "profile",
                icon: Image.asset(
                  "assets/images/profile.png",
                  height: 20,
                ),
              ),
            ]));
  }
}
