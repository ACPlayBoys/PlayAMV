import 'package:flutter/material.dart';
import 'package:playamv/utils/storage.dart';
import 'package:velocity_x/velocity_x.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //User? user = FirebaseAuth.instance.currentUser;
     return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
            onTap: () => print("tap"),
            child: buildBtns(Icons.person, "Your Details", 50,
                Theme.of(context).buttonColor)),
        15.heightBox,
        15.heightBox,
        InkWell(
            onTap: () => print("tap"),
            child: buildBtns(
                Icons.settings, "Settings", 50, Theme.of(context).buttonColor)),
        15.heightBox,
        InkWell(
            onTap: () => print("tap"),
            child: buildBtns(Icons.help, "Help & Support", 50,
                Theme.of(context).buttonColor)),
        15.heightBox,
        InkWell(
            onTap: () => print("tap"),
            child: buildBtns(Icons.person_remove_sharp, "Sign Out", 30,
                Theme.of(context).buttonColor)),
        15.heightBox,
      ],
    ).scrollVertical();
  }
}

class buildBtns extends StatelessWidget {
  final icon1;
  final String label;
  final double size;
  final color;

  const buildBtns(this.icon1, this.label, this.size, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: size == 50 ? null : 200,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(50)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon1),
          Spacer(),
          label.text.bold.xl.make(),
          Spacer(),
          Icon(size == 50 ? Icons.forward : Icons.exit_to_app_rounded),
        ],
      ).px12(),
    );
  }
}
