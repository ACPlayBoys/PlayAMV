// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:playamv/screens/create_screen.dart';
import 'package:playamv/utils/routes.dart';
import 'package:playamv/utils/storage.dart';
import 'package:playamv/widgets/upload.dart';
import 'package:video_player/video_player.dart';
import "package:velocity_x/velocity_x.dart";
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  bool visible = false;
  var chngBtn = 0;

  bool signin = true;

  bool play = true;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      postsignin();
    }

    _controller = VideoPlayerController.network(
        'https://storage.kanzaki.ru/ANIME___/Golden_Time/%5bJacobSwaggedUp%5d%20Golden%20Time%20-%2001%20%28BD%201280x720%29.mp4')
      ..initialize().then((_) {
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.

        _controller.addListener(() {
          if (_controller.value.position.inSeconds > 11 && visible == false) {
            visible = true;
            _controller.setVolume(0);
            setState(() {});
          }
        });
        setState(() {});
      });

    play ? _controller.play() : _controller.pause();
  }

  postsignin() async {
    play = false;
    await Future.delayed(Duration(seconds: 1));
    await Storage.setUser(FirebaseAuth.instance.currentUser);
    await Navigator.of(context).push(Routes.homeRoute());
  }

  Future<User?> _signin() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication? gsa =
          await googleSignInAccount?.authentication;
      OAuthCredential user = GoogleAuthProvider.credential(
        accessToken: gsa?.accessToken,
        idToken: gsa?.idToken,
      );

      setState(() {
        chngBtn = 2;
      });
      await _auth.signInWithCredential(user);
      User? id = _auth.currentUser;
      Storage.setUser(_auth.currentUser);
      return id;
    } on Exception catch (e) {
      // TODO
      chngBtn = 0;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var button1 = Material(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(50),
      child: InkWell(
        onTap: () async {
          setState(() {
            chngBtn = 1;
          });
          User? user = await _signin();
          if (user != null) {
            setState(() {});
            await Future.delayed(Duration(seconds: 1));
            await Storage.setUser(user);
            await Navigator.of(context).push(Routes.homeRoute());
          }
          setState(() {
            chngBtn = 0;
          });
        },
        child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: chngBtn == 1 ? 50 : 150,
            height: 50,
            alignment: Alignment.center,
            child: buildButton()),
      ),
    );
    return Scaffold(
      body: Stack(
        children: [
          _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : Container(
                  child: CircularProgressIndicator().centered(),
                ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Container(
              color: Color.fromARGB(29, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: chngBtn == 1 ? 50 : 150,
                          height: 50,
                          alignment: Alignment.center,
                          child: button1)
                      .centered(),
                ],
              ),
            ),
            crossFadeState:
                visible ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: Duration(seconds: 2),
          ).centered(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        onPressed: () {
          setState(() {
            _controller.value.isPlaying
                ? _controller.pause()
                : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Container buildButton() {
    if (chngBtn == 1) {
      return Container(
          child: CircularProgressIndicator(
              color: Theme.of(context).backgroundColor));
    } else if (chngBtn == 2) {
      return Container(
        child: Icon(
          Icons.done,
          color: Colors.white,
        ),
      );
    } else
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Image.asset('assets/giphy.gif').image,
          ),
          shape: BoxShape.circle,
        ),
      );
  }
}
