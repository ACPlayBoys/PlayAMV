// ignore_for_file: unnecessary_this, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:playamv/Models/user.dart';
import 'package:playamv/widgets/profile/get_videos.dart';
import 'package:playamv/widgets/profile/liked_Videos.dart';
import 'package:velocity_x/velocity_x.dart';

class Content extends StatefulWidget {
  final UserAccount user;
  const Content(this.user, {Key? key}) : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> with TickerProviderStateMixin {
  late TabController tabbar;

  @override
  void initState() {
    // ignore: todo
    tabbar = TabController(length: 2, vsync: this); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.user.first_name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Align(
            alignment: Alignment.topCenter,
            child: TabBar(
                controller: tabbar,
                labelPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                unselectedLabelColor: Colors.grey,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                indicator: CircleTabIndicator(
                    color: Theme.of(context).accentColor, radius: 2),
                tabs: [
                  "Your Videos".text.xl.make(),
                  "Liked Videos".text.xl.make(),
                ]),
          ),
        ),
        Container(
                child: TabBarView(
                    controller: tabbar,
                    children: [GetVideos(this.widget.user).p4(), LikedVideos(this.widget.user).p4()]))
            .expand()
      ],
    );
  }
}

class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CirclePainter(color: color, radius: radius);
  }
}

class _CirclePainter extends BoxPainter {
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    late Paint _paint;
    _paint = Paint()..color = color;
    _paint = _paint..isAntiAlias = true;
    final Offset circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
