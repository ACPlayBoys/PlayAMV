import 'dart:io';

import 'package:flutter/material.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/Models/video.dart';
import 'package:playamv/screens/create_screen.dart';
import 'package:playamv/screens/home_screen.dart';
import 'package:playamv/screens/profile_screen.dart';
import 'package:playamv/widgets/upload.dart';
import 'package:playamv/widgets/video_widget.dart';

class Routes{
  static Route createRoute(File file,String filename) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => UploadWidget(file,filename),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  static Route homeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  
  static Route profileRoute(UserAccount user) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => Profile_Screen(user),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
  static Route singleVideoRoute(Video vid,UserAccount uid) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => VideoWidget(vid,uid),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}